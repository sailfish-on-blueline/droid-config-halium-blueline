#!/bin/sh
# Pixel 3's Qualcomm HWC2 must remain the hardware compositor.
set -eu
mkdir -p /run/droid-hal
# Sailfish supplies /data as a plaintext bind mount. Android's fstab and
# StrongBox startup barrier assume encrypted Android userdata.
sed '/^[[:space:]]*exec_start wait_for_strongbox[[:space:]]*$/d' \
    /vendor/etc/init/hw/init.sdm845.rc > /run/droid-hal/init.sdm845.rc.tmp
mv /run/droid-hal/init.sdm845.rc.tmp /run/droid-hal/init.sdm845.rc
mount --bind /run/droid-hal/init.sdm845.rc /vendor/etc/init/hw/init.sdm845.rc
awk '$2 != "/data" && $2 != "/metadata"' /vendor/etc/fstab.sdm845 \
    > /run/droid-hal/fstab.sdm845.tmp
mv /run/droid-hal/fstab.sdm845.tmp /run/droid-hal/fstab.sdm845
mount --bind /run/droid-hal/fstab.sdm845 /vendor/etc/fstab.sdm845
# Load vendor firmware directly before starting the hardware services.
printf '%s' /vendor/firmware > /sys/module/firmware_class/parameters/path
# Android init disables kernel module autoloading. Load the touchscreen
# drivers before the container starts.
modprobe ftm5
modprobe sec_touch
# Load the rebuilt module before the Android Wi-Fi service starts.
modprobe wlan || true
