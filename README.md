# Pixel 3 Sailfish device configuration

Device configuration and image patterns for Google Pixel 3, Sailfish OS 5.2.0.22 and Halium 12. Includes camera access and firmware handling, sensor mappings, vibrator and power settings, volume-key input, compositor configuration and the ConnMan WLAN blacklist.

```sh
git clone --recurse-submodules https://github.com/sailfish-on-blueline/droid-config-halium-blueline.git
cd droid-config-halium-blueline
rpmbuild --build-in-place --nodeps --target aarch64 -bb rpm/droid-config-halium-blueline.spec
```

Build in the Sailfish Platform SDK with the Halium 12 repositories configured. `droid-configs-device` is a Git submodule pinned to the shared device-packaging implementation. Runtime symlinks under `sparse` are installed into the filesystem by the RPM.

`patches/gst-droid-codec-fix.patch` contains the AAC/H.264 repairs for gst-droid commit `e5152aee90dbb9b81c6bc45073b1fa86fc0c4194`. `patches/fingerterm-popup-touch-fix.patch` applies to the QML shipped in FingerTerm 1.4.16. The image uses `gstreamer1.0-droid-0.20260508.1-1.9.3.blueline` and `fingerterm-1.4.16-1.16.4.blueline` rebuilt with these patches.
