# Inherit from those products. Most specific first.
PRODUCT_APEX_SYSTEM_SERVER_JARS += \
    com.android.crashrecovery:service-crashrecovery

$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Omni stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from aurora device
$(call inherit-product, device/xiaomi/aurora/device.mk)

PRODUCT_DEVICE := aurora
PRODUCT_NAME := twrp_aurora
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 24031PN0DC
PRODUCT_MANUFACTURER := xiaomi

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRIVATE_BUILD_DESC="aurorapro-user 14 UKQ1.240523.001 OS2.0.101.0.VNACNXM release-keys"

BUILD_FINGERPRINT := Xiaomi/aurorapro/aurora:14/UKQ1.240523.001/OS2.0.101.0.VNACNXM:user/release-keys

PRODUCT_CHECK_PREBUILT_MAX_PAGE_SIZE := false

# Copy libsysutils and updated recovery.fstab into recovery ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery.fstab