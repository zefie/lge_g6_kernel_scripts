# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string="%NAME% kernel for %MANU% %MODEL% by %KERNELDEV%"
do.devicecheck=1
do.modules=0 # we will do it ourself.
do.cleanup=1
do.cleanuponabort=0
device.name1=%MODEL_WHITELIST%
device.name2=
device.name3=
device.name4=
device.name5=

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
force_seandroid=1;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;

## zefie kernel info

ui_print " "
ui_print "Kernel Device: %MANU% %MODEL% (%DEVMODEL%)"
ui_print "Kernel Name: %NAME%"
ui_print "Kernel Maintainer: %KERNELDEV%"
ui_print "Kernel Version: %VERSION%"
ui_print "Toolchain: %TOOLCHAIN_VERSION%"
ui_print " "

## AnyKernel install

# Dump initrd
dump_boot;

# remove /sbin/rctd if it exists
if [ -f "$ramdisk/sbin/rctd" ]; then
	ui_print "Removing /sbin/rctd..."
	rm -f "$ramdisk/sbin/rctd"
fi

if [ -f "$ramdisk/init.lge.rc" ]; then
	if [ "$(grep /sbin/rctd $ramdisk/init.lge.rc | wc -l)" -gt "0" ]; then
		ui_print "Removing rctd service from init.lge.rc..."
		cat $ramdisk/init.lge.rc | sed -e '/\/sbin\/rctd/,+4d' > $ramdisk/init.lge.rc.new
		mv $ramdisk/init.lge.rc.new $ramdisk/init.lge.rc
	fi
fi

if [ "$(cat $ramdisk/fstab.lucye | grep forceencrypt | wc -l)" -gt "0" ]; then
	ui_print "Disabling forceencrypt..."
	cat $ramdisk/fstab.lucye | sed -e 's/forceencrypt/encryptable/' > $ramdisk/fstab.lucye.new
	mv $ramdisk/fstab.lucye.new $ramdisk/fstab.lucye
fi

# write new boot
write_boot;

# Manual module install
ui_print "Installing modules...";
mount -o rw,remount -t auto /system;

rm -rf /system/lib/modules
mkdir -p /system/lib/modules

cp -rf /tmp/anykernel/modules/* /system/lib/modules/;
set_perm_recursive 0 0 0755 0644 /system/lib/modules;

mount -o ro,remount -t auto /system;
## end install
