#
# Copyright (C) 2021 The TWRP Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# Include GSI keys
$(call inherit-product, $(SRC_TARGET_DIR)/product/gsi_keys.mk)

# Virtual A/B support
# # https://source.android.com/docs/core/ota/virtual_ab/implement#build-flags
$(call inherit-product, $(SRC_TARGET_DIR)/product/virtual_ab_ota.mk)
AB_OTA_UPDATER := true
ENABLE_VIRTUAL_AB := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# A/B updater updatable partitions list. Keep in sync with the partition list
# with "_a" and "_b" variants in the device. Note that the vendor can add more
# more partitions to this list for the bootloader and radio.

# TODO: Virtual A/B partitions found on denniz's full OTA payload.
AB_OTA_PARTITIONS := \
    my_product \
    my_engineering \
    my_company \
    my_carrier \
    my_region \
    my_heytap \
    my_stock \
    my_preload \
    my_bigball \
    my_manifest \
    odm \
    product \
    system \
    system_ext \
    vendor \

# TODO: Normal A/B partitions found on denniz's full OTA payload.
AB_OTA_PARTITIONS += \
    audio_dsp \
    boot \
    cam_vpu1 \
    cam_vpu2 \
    cam_vpu3 \
    cdt_engineering \
    dpm \
    dtbo \
    gz \
    lk \
    mcupm \
    md1img \
    pi_img \
    preloader_raw \
    scp \
    spmfw \
    sspm \
    tee \
    vbmeta \
    vbmeta_system \
    vbmeta_vendor \

# TODO: Other A/B partitions found on denniz's partitions, but not full OTA.
# AB_OTA_PARTITIONS += \
#     vendor_boot \

# Update engine
PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier

PRODUCT_PACKAGES_DEBUG += \
    update_engine_client

# A/B postinstall
AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=ext4 \
    POSTINSTALL_OPTIONAL_system=true

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=ext4 \
    POSTINSTALL_OPTIONAL_vendor=true

PRODUCT_PACKAGES += \
    checkpoint_gc \
    otapreopt_script

# Boot control HAL
PRODUCT_PACKAGES += \
    android.hidl.base@1.0 \
    android.hardware.boot@1.2-impl \
    android.hardware.boot@1.2-impl.recovery \
    android.hardware.boot@1.2-service

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    fastbootd

# Additional binaries & libraries needed for recovery
TARGET_RECOVERY_DEVICE_MODULES += \
    libkeymaster4 \
    libkeymaster41

RECOVERY_LIBRARY_SOURCE_FILES += \
	$(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster4.so \
    $(TARGET_OUT_SHARED_LIBRARIES)/libkeymaster41.so
