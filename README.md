# Proprietary vendor blobs for Lenovo Idea Tab Pro Gen 2 (malbec)

Blobs extracted from the stock firmware of the Lenovo TB390FU (codename
`malbec`, Qualcomm SM8735P, silicon codename TunaP, `soc_id` 694).

## Source firmware

```
TB390FU_ROW_OPEN_USER_Q00012.1_A16_ZUI_18.0.10.335_ST_260618
Android 16 (SDK 36) / vendor API level 202404
Security patch 2026-05-05
```

3287 entries. `proprietary-files.txt` in the device tree is the authoritative
list; everything here — `Android.bp`, `Android.mk`, `BoardConfigVendor.mk`,
`malbec-vendor.mk` and `proprietary/` — is generated from it and should not be
edited by hand.

## Regenerating

```bash
cd device/lenovo/malbec
./extract-files.py <path-to-dump>
```

## Symlinks

199 of the stock vendor symlinks are relative and are declared with `;SYMLINK=`
in `proprietary-files.txt`, so extract-utils emits an `install_symlink` for each
instead of a copy. 188 of them point at `toybox_vendor`; dereferencing them —
which an earlier revision of the generator did — turned one 577 KB binary into
188 identical files and cost 110.7 MB.

Symlinks whose target is an absolute runtime path (`/data/vendor/firmware`,
`/mnt/vendor/persist/<chip>/wlan_mac.bin`, …) cannot be expressed this way and
live in `device/lenovo/malbec/Android.bp` as hand-written `install_symlink`
modules.

## What is deliberately absent

**Anything the build generates.** `vendor/etc/passwd`, `group`,
`fs_config_files`, `fs_config_dirs`, `NOTICE.xml.gz`, the vintf compatibility
matrix, the three per-SoC `manifest_*.xml`, and all of `vendor/etc/selinux/`.
Each of those is produced from the device tree — `configs/config.fs`,
`DEVICE_MATRIX_FILE`, `DEVICE_MANIFEST_FILE`, `BOARD_VENDOR_SEPOLICY_DIRS` —
and a blob copy would be a second rule writing the same path. The selinux set
matters most: the stock `vendor_sepolicy.cil` is compiled against Lenovo's
platform policy and will not load against this one.

**The Wi-Fi stack.** `wpa_supplicant`, `hostapd`, `android.hardware.wifi-service`
and their init and vintf files are built from source, as on onyx. The stock
copies target an Android 15 vendor while the framework here is Android 16. The
per-device tuning files (`WCNSS_qcom_cfg.ini` for each chip directory,
`vendor_cmd.xml`, the supplicant overlays, `etc/hostapd/*`) do stay, since
those are this board's configuration and do not exist in AOSP.

**The cellular stack** on `system_ext` and `product` — qcril, IMS, RCS, UIM.
TB390FU is a Wi-Fi only tablet with no modem.

**`vendor/etc/fstab.qcom`.** The device tree ships its own; the stock one mounts
`dataext` and `vm-bootsys`, neither of which this build produces an image for.

**Firmware images.** No `proprietary-firmware.txt`. The bootloader, TrustZone
and modem are left on stock, which keeps a failed boot recoverable.

**`vendor/overlay/`** (7 RROs). extract-utils has no packaging rule for that
directory. If Wi-Fi band or feature configuration turns out wrong,
`WifiResTarget.apk` and `WifiResMainlineTarget.apk` are the first place to look;
they would have to be installed by hand through `PRODUCT_COPY_FILES`.

**`vendor/etc/assets/`** (670 MB). The "PC Engine" local Linux container images
— `usrimg` is a 620 MB EROFS that `vendor/bin/lrootfs.sh` loop-mounts as the
container's `/usr`. The feature is out of scope for this port, and both files
exceed GitHub's 100 MB per-file limit.

## Git LFS

`proprietary/vendor/lib64/libarcsoft_faceid.so` is 128 MB, over GitHub's hard
limit, and is tracked with Git LFS. It backs
`android.hardware.biometrics.face`, whose service runs on the stock ROM, so it
is not something that can simply be dropped.

Three more files sit in the 50–100 MB warning band —
`libQnnHtpPrepare.so`, `libpat_uint8.so` and `rfs/dsp/libvpt_action_recognition.so`
— and are left as ordinary git objects on purpose: LFS bandwidth is metered per
clone, and only the one file that GitHub actually refuses needs it.

Clone with `git lfs install` configured, or that file arrives as a pointer.

## Licensing

These files are redistributed under the terms granted by their respective
copyright holders, for use with the device they were extracted from. If you are
a rights holder and object to their inclusion, open an issue.
