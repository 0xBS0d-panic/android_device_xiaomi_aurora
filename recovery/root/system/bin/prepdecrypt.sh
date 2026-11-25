#!/system/bin/sh
SLOT=$(getprop ro.boot.slot_suffix)
mkdir -p /firmware /vendor/firmware /mnt/vendor/persist /tmp/sys_mnt \
         /tmp/a14_env/system/lib64 /tmp/a14_env/system/bin \
         /tmp/a14_env/vendor /tmp/a14_env/dev /tmp/a14_env/proc \
         /tmp/a14_env/sys /tmp/a14_env/mnt/vendor/persist

mount -o ro /dev/block/bootdevice/by-name/modem${SLOT} /firmware
mount -o ro /vendor 2>/dev/null
mount -o bind /firmware/image /vendor/firmware
mount /mnt/vendor/persist 2>/dev/null
mount -o ro /dev/block/mapper/system${SLOT} /tmp/sys_mnt

insmod /lib/modules/qcom_q6v5.ko 2>/dev/null
insmod /lib/modules/qcom_q6v5_pas.ko 2>/dev/null
echo start > /sys/class/remoteproc/remoteproc0/state 2>/dev/null

cp -a /tmp/sys_mnt/system/lib64/*.so /tmp/a14_env/system/lib64/
cp -f /tmp/sys_mnt/system/lib64/bootstrap/*.so /tmp/a14_env/system/lib64/
cp -f /vendor/lib64/libutils.so /vendor/lib64/libcutils.so /tmp/a14_env/system/lib64/
cp -fL /tmp/sys_mnt/system/bin/bootstrap/linker64 /tmp/a14_env/system/bin/linker64 2>/dev/null || \
    cp -fL /tmp/sys_mnt/system/bin/linker64 /tmp/a14_env/system/bin/linker64
chmod 755 /tmp/a14_env/system/bin/linker64

mount -o bind /dev /tmp/a14_env/dev
mount -o bind /dev/binderfs /tmp/a14_env/dev/binderfs
mount -t proc proc /tmp/a14_env/proc
mount -t sysfs sysfs /tmp/a14_env/sys
mount -o bind /vendor /tmp/a14_env/vendor
mount -o bind /mnt/vendor/persist /tmp/a14_env/mnt/vendor/persist

chroot /tmp/a14_env /vendor/bin/ssgtzd &
sleep 1
chroot /tmp/a14_env /vendor/bin/hw/android.hardware.security.keymint-service-qti &
chroot /tmp/a14_env /vendor/bin/hw/android.hardware.gatekeeper-service-qti &
setprop crypto.ready 1
