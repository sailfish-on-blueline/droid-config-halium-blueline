# Pixel 3 Sailfish device configuration

Device configuration and image patterns for Google Pixel 3, Sailfish OS 5.2.0.22 and Halium 12. Includes camera access and firmware handling, sensor mappings, vibrator and power settings, volume-key input, compositor configuration and the ConnMan WLAN blacklist.

```sh
git clone --recurse-submodules https://github.com/sailfish-on-blueline/droid-config-halium-blueline.git
cd droid-config-halium-blueline
rpmbuild --build-in-place --nodeps --target aarch64 -bb rpm/droid-config-halium-blueline.spec
```

Build in the Sailfish Platform SDK with the Halium 12 repositories configured. `droid-configs-device` is a Git submodule pinned to the shared device-packaging implementation. Runtime symlinks under `sparse` are installed into the filesystem by the RPM.

`patches/gst-droid-codec-fix.patch` contains the AAC/H.264 repairs for gst-droid commit `e5152aee90dbb9b81c6bc45073b1fa86fc0c4194`. `patches/fingerterm-popup-touch-fix.patch` applies to the QML shipped in FingerTerm 1.4.16. The image uses `gstreamer1.0-droid-0.20260508.1-1.9.3.blueline` and `fingerterm-1.4.16-1.16.4.blueline` rebuilt with these patches.

The PulseAudio card loads `sparse/etc/pulse/blueline-audio-policy.xml` with a 16-bit PCM input default. The policy adds the Pixel 3 HAL's negotiated PCM16 format at 48 kHz and resolves its vendor includes. The policy retains the AOSP Apache 2.0 notice, with the license included in the PulseAudio settings package.

`patches/pulseaudio-droid-input-pacing-fix.patch` applies to PulseAudio droid modules 14.2.110, commit `7ca34ded1109f15965a0bb059590bbbdf26185ae`. It schedules the next input buffer after a failed reopen or an empty or failed read. The configuration requires `pulseaudio-modules-droid-14.2.110-1.26.2.blueline`. Workspace builds use `scripts/build-pulseaudio-input-rpm.py` to rebuild this RPM from the matching Sailfish 5.2 package inputs.
