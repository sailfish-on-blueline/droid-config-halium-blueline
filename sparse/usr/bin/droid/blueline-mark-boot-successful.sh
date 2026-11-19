#!/bin/sh
set -eu
# Pixel 3's supplied bootctrl.sdm845 HAL stores slot state in GPT attributes.
# Use that HAL through Android bootctl instead of assuming a BCB layout.
for attempt in 1 2 3 4 5 6; do
    if lxc-attach -n android -- /system/bin/bootctl mark-boot-successful; then
        echo "Pixel 3 boot slot marked successful"
        exit 0
    fi
    sleep 5
done
echo "Unable to mark the current Pixel 3 boot slot successful" >&2
exit 1
