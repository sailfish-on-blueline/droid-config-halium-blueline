%package -n patterns-sailfish-device-adaptation-halium-blueline
Summary: Pixel 3 Halium 12 hardware adaptation
Requires: kernel-adaptation-halium-blueline
Requires: droid-config-halium-blueline-sailfish
Requires: droid-config-halium-blueline-pulseaudio-settings
Requires: droid-config-halium-blueline-policy-settings
Requires: droid-config-halium-blueline-preinit-plugin
Requires: droid-config-halium-blueline-flashing
Requires: droid-config-halium-blueline-bluez5
Requires: droid-hal-version-halium-blueline
Requires: droid-hal-vendor-img-halium-blueline
Requires: lxc
Requires: halium-android-rootfs = 12.0
Requires: libhybris >= 0.0.5.48
Requires: libhybris-libEGL
Requires: libhybris-libGLESv2
Requires: libhybris-libwayland-egl
Requires: qt5-plugin-generic-evdev
Requires: qt5-qtwayland-wayland_egl
Requires: qt5-qpa-hwcomposer-plugin
Requires: qtscenegraph-adaptation
Requires: bluez5-tools
Requires: bluebinder
Requires: ofono-binder-plugin
Requires: ofono-binder-plugin-ext-qti
Requires: dummy_netd
Requires: nfcd-binder-plugin
Requires: nfcd-mce-plugin
Requires: libgbinder-tools
Requires: acl
Requires: sailfish-fpd-community
Requires: sailfish-devicelock-fpd
Requires: libngf-qt5-qtfeedback
Requires: ngfd-plugin-native-vibrator
Requires: hybris-libsensorfw-qt5
Requires: pulseaudio-modules-droid
Requires: pulseaudio-modules-droid-hidl
Requires: audiosystem-passthrough-dummy-af
Requires: qt5-qtmultimedia-plugin-mediaservice-gstmediacapture
Requires: gstreamer1.0
Requires: gstreamer1.0-plugins-good
Requires: gstreamer1.0-plugins-base
Requires: gstreamer1.0-plugins-bad
Requires: nemo-gstreamer1.0-interfaces
Requires: gstreamer1.0-droid
Requires: gmp-droid
Requires: mce-plugin-libhybris
Requires: usb-moded
Requires: rfkill
Requires: geoclue-provider-hybris

%description -n patterns-sailfish-device-adaptation-halium-blueline
AOSP Android 12 based Google Pixel 3 hardware adaptation.

%files -n patterns-sailfish-device-adaptation-halium-blueline
