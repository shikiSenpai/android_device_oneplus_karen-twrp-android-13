TWRP device tree for OnePlus Nord 2T 5G (denniz)
===============================================

| Basic                   | Spec Sheet                                                                                                                     |
| -----------------------:|:------------------------------------------------------------------------------------------------------------------------------ |
| Codename                | `denniz`                                                                                                                        |
| Device name             | `OP515BL1` (OnePlus Nord 2T 5G)                                                                                                |
| Model names             | `CPH2399` "EU" global model<br/>`CPH2401` India model                                                                          |
| CPU                     | Octa-core                                                                                                                      |
| Chipset                 | MediaTek MT6893 Dimensity 1300 5G (6 nm) (MT6893Z_Z/CZA)                                                                       |
| GPU                     | Mali-G77 MC9                                                                                                                   |
| Memory                  | 8/12 GB RAM                                                                                                                    |
| Shipped Android Version | Android 12.1 (OxygenOS 12.1)                                                                                                   |
| Storage                 | 128/256 GB                                                                                                                     |
| Battery                 | Li-Po 4500 mAh, non-removable                                                                                                  |
| Display                 | AMOLED, 90Hz, HDR10+ 1080 x 2400 pixels, 20:9 ratio (~409 ppi density)                                                         |
| Camera (Back)(Main)     | 50 MP, f/1.8, 24mm (wide), 1/1.56", 1.0µm, PDAF, OIS<br/>8 MP, f/2.2, 120˚ (ultrawide)<br/>2 MP, f/2.2, (monochrome)           |
| Camera (Front)          | 32 MP, f/2.4, (wide), 1/2.8", 0.8µm                                                                                            |

![image](https://fdn2.gsmarena.com/vv/pics/oneplus/oneplus-nord-2t-5g-1.jpg)

### BOARD_USES_RECOVERY_AS_BOOT

Keep in mind, `denniz` has NO `recovery` partition.
Recovery is part of the boot partition, so it takes care of normal boot and recovery.

**SO MAKE SURE YOU HAVE A BACKUP `boot.img`**

### Building

Basic instructions. From there you'll need to research.

1. Get started with https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp/tree/twrp-12.1
   ```
   repo init -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-12.1
   repo sync -j5 --current-branch --no-clone-bundle --no-tags
   ```

1. Add this device tree to `device/oneplus/denniz`.
   ```
   mkdir -p device/oneplus
   cd device/oneplus
   git clone https://github.com/oneplus-denniz-roms/android_device_oneplus_denniz-twrp.git denniz
   cd ../..
   ```

1. Try an `eng` build.
   ```
   export ALLOW_MISSING_DEPENDENCIES=true; . build/envsetup.sh; lunch twrp_denniz-eng
   make bootimage
   ```

1. You should now be able to flash `out/target/product/denniz/boot.img`
   ```
   cd out/target/product/denniz
   fastboot flash boot boot.img
   ```

### Experimental builds

#### 1. Flash *just* TWRP

https://github.com/oneplus-denniz-roms/android_device_oneplus_denniz-twrp/releases

Find the `.img` files under a releases' assets.
And flash like normal. `fastboot flash boot twrp-boot-xxx.img`

#### 2. Install the ramdisk

Boot into TWRP, then:
- `adb push stock-boot.img /sdcard/stock-boot.img` (get this from an official OTA file).
- `adb push twrp-boot-xxx.img /sdcard/twrp-boot-xxx.img`
- Install the **Stock** `stock-boot.img` for your OS version. **DO NOT** reboot yet.
- Install the ramdisk from `/sdcard/twrp-boot-xxx.img`. **DO NOT** reboot yet.
- `adb shell` -> `dd if=/dev/block/by-name/boot of=/sdcard/boot-plus-twrp.img` (You will need this for rooting).
- `adb reboot`

#### 3. Rooting

Booting the phone normally:
- Open the Magisk app.
- Choose `/sdcard/boot-plus-twrp.img` to be patched.
- Note the filename you get in the log `/sdcard/Download/magisk_patched-XXXXXXX.img`
- `adb reboot recovery`

When rebooted to TWRP:
- Install the file you got `/sdcard/Download/magisk_patched-XXXXXXX.img` to Boot.
- Reboot! You're done!
