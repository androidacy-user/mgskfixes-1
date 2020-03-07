set_moto_props() {
# Passing SafetyNet on some Motorola devices
echo "partition.oem.verified 2
partition.vendor.verified 2
partition.system.verified 2
" > $MODPATH/system.prop
# Just to be sure, lets set those props again
echo "resetprop partition.oem.verified 2
resetprop partition.vendor.verified 2
resetprop partition.system.verified 2
" > $MODPATH/service.sh
}

# If the vendor has the libs don't use ours
if [ -f /vendor/lib*/libdirect-coredump.so ];
then
	cp -rf /vendor/lib64/libdirect-coredump.so $MODPATH/system/lib64
	cp -rf /vendor/lib/libdirect-coredump.so $MODPATH/system/lib;
fi
# Originally by phhusson, Adapted by linuxandria
if getprop ro.vendor.build.fingerprint |grep -q -e google/;
then
	ui_print "- Google device detected!"
	if [ -f /system/phh/google-uinput-fpc.kl ];
	then
		echo "cp /system/phh/google-uinput-fpc.kl /mnt/phh/keylayout/uinput-fpc.kl" >> $MODPATH/post-fs-data.sh
		echo "chmod 0644 /mnt/phh/keylayout/uinput-fpc.kl" >> $MODPATH/post-fs-data.sh
		echo "mount -o bind /mnt/phh/keylayout /system/usr/keylayout" >> $MODPATH/post-fs-data.sh
		echo "restorecon -R /system/usr/keylayout" >> $MODPATH/post-fs-data.sh;
	fi
fi
if getprop ro.product.vendor.brand|grep -q -e motorola/;
then
	set_moto_props ;
	echo "mount -o bind $MODDIR/vendor/bin/init.mmi.hab.sh /vendor/bin/init.mmi.hab.sh" >> $MODPATH/post-fs-data.sh
fi
