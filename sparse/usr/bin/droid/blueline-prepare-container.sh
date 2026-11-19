#!/bin/sh
set -eu
cp /usr/share/halium-blueline/lxc.conf /var/lib/lxc/android/config
mkdir -p /run/droid-hal /dev/__properties__ /dev/socket
mountpoint -q /sys/fs/cgroup || mount -t tmpfs cgroup /sys/fs/cgroup
for module in $(find /lib/modules/"$(uname -r)" -name '*.ko'); do
    target=/vendor/lib/modules/$(basename "$module")
    if [ -f "$target" ] && ! mountpoint -q "$target"; then
        mount --bind "$module" "$target"
    fi
done
