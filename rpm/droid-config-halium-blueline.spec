%define device halium-blueline
%define vendor google
%define vendor_pretty Google
%define device_pretty Pixel 3
%define otherdevice blueline
%define community_adaptation 1
%define provides_own_board_mapping 1
%define disable_tools 1
%define pixel_ratio 1.75
%define ofono_enable_plugins bluez5,hfp_ag_bluez5
%define ofono_disable_plugins bluez4,dun_gw_bluez4,hfp_ag_bluez4,hfp_bluez4,dun_gw_bluez5,hfp_bluez5
Provides: ofono-configs-binder
Provides: ofono-configs
Requires: droid-config-halium
Requires: acl
Requires: pulseaudio-modules-droid >= 14.2.110-1.26.2.blueline
AutoReqProv: no
%include droid-configs-device/droid-configs.inc
%include patterns/patterns-sailfish-device-adaptation-halium-blueline.inc
%include patterns/patterns-sailfish-device-configuration-halium-blueline.inc
