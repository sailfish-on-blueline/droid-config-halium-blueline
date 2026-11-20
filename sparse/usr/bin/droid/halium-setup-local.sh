#!/bin/sh
# Pixel 3's Qualcomm HWC2 must remain the hardware compositor.
set -eu
mkdir -p /run/droid-hal
# Sailfish supplies /data as a plaintext bind mount. Android's fstab and
# StrongBox startup barrier assume encrypted Android userdata.
sed -e '/^[[:space:]]*exec_start wait_for_strongbox[[:space:]]*$/d' \
    -e '/^service ppd[[:space:]]/a\    oneshot' \
    /vendor/etc/init/hw/init.sdm845.rc > /run/droid-hal/init.sdm845.rc.tmp
mv /run/droid-hal/init.sdm845.rc.tmp /run/droid-hal/init.sdm845.rc
mount --bind /run/droid-hal/init.sdm845.rc /vendor/etc/init/hw/init.sdm845.rc
# Full system suspend pauses timers while Sailfish's watchdog owner is frozen.
sed -e 's@^\([[:space:]]*write /sys/power/mem_sleep[[:space:]]*\)"s2idle"[[:space:]]*$@\1"deep"@' \
    -e 's@#Enable suspend to idle mode to reduce latency during suspend/resume@#Use full system suspend with the Sailfish userspace watchdog@' \
    /vendor/etc/init/hw/init.sdm845.power.rc > /run/droid-hal/init.sdm845.power.rc.tmp
mv /run/droid-hal/init.sdm845.power.rc.tmp /run/droid-hal/init.sdm845.power.rc
mount --bind /run/droid-hal/init.sdm845.power.rc /vendor/etc/init/hw/init.sdm845.power.rc
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
