#!/bin/sh
set -eu
export LC_ALL=C

parameters_dir=$(mktemp -d /run/blueline-keymaster.XXXXXX)
trap 'rm -rf "$parameters_dir"' EXIT HUP INT TERM
nonce_types='i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8 i8'

# Android normally performs this agreement through keystore during startup.
# The Halium container supplies both hardware HALs without that service.
# The packaged binder-call returns 2 for completed transactions. Check the
# decoded HAL status and payload below before accepting those transactions.
for instance in default strongbox; do
    binder-call -q -d /dev/hwbinder \
        "android.hardware.keymaster@4.0::IKeymasterDevice/$instance" \
        2 reply i32 i32 "{ [ i8 ] { $nonce_types } }" \
        > "$parameters_dir/$instance.parameters" || [ "$?" -eq 2 ]

    awk '
        $1 != "0" || $2 != "0" { exit 1 }
        {
            start = index($0, "{")
            if (!start) exit 1
            for (i = 3; i <= NF; i++) {
                if ($i == "[") part = 1
                if ($i == "]") part = 2
                if ($i ~ /^-?[0-9]+:8$/) {
                    byte = $i
                    sub(/:8$/, "", byte)
                    if (byte < -128 || byte > 255) exit 1
                    if (byte < 0) byte += 256
                    if (part == 1) {
                        seed_count++
                        seed_key = seed_key sprintf("%02x", byte)
                    } else {
                        nonce_count++
                        nonce_key = nonce_key sprintf("%02x", byte)
                    }
                }
            }
            if (seed_count != 0 && seed_count != 32) exit 1
            if (nonce_count != 32) exit 1
            printf "%s!%s|%s\n", seed_key, nonce_key, substr($0, start)
            valid = 1
        }
        END { if (!valid) exit 1 }
    ' "$parameters_dir/$instance.parameters" \
        > "$parameters_dir/$instance.sorted-parameters"
done

# HIDL requires lexicographic ordering by seed and then nonce.
parameters_argument=$(
    printf '[ '
    sort "$parameters_dir/default.sorted-parameters" \
        "$parameters_dir/strongbox.sorted-parameters" \
        | cut -d '|' -f 2- | tr '\n' ' '
    printf ' ]'
)

for instance in default strongbox; do
    binder-call -q -d /dev/hwbinder \
        "android.hardware.keymaster@4.0::IKeymasterDevice/$instance" \
        3 "$parameters_argument" reply i32 i32 '[ i8 ]' \
        > "$parameters_dir/$instance.check" || [ "$?" -eq 2 ]

    awk '
        $1 != "0" || $2 != "0" { exit 1 }
        {
            for (i = 3; i <= NF; i++) {
                if ($i ~ /^-?[0-9]+:8$/) byte_count++
            }
            valid = byte_count == 32
        }
        END { if (!valid) exit 1 }
    ' "$parameters_dir/$instance.check"
done

cmp -s "$parameters_dir/default.check" "$parameters_dir/strongbox.check"
lxc-attach -n android -- /system/bin/setprop ctl.start vendor.fps_hal
