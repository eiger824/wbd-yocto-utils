#!/bin/bash

if [[ ! -b /dev/sdb1 ]] || [[ ! -b /dev/sdb2 ]]
then
	echo "Insert SD card"
	exit 1
fi

df | grep -qi sdb

if [ "$?" == "0" ]
then
	echo "Mounted, unmounting..."
	sudo umount /dev/sdb1 &> /dev/null
	sudo umount /dev/sdb2 &> /dev/null
	echo "Done, continuing"
fi

echo -n "About to launch fdisk, enter any key "
read foo
sudo fdisk /dev/sdb

if [[ -z $MACHINE ]]
then
	echo "Asumming wandboard"
	MACHINE="wandboard"
else
	echo "Machine is $MACHINE"
fi

IMAGES=$(find ./tmp/deploy/images/$MACHINE/ -type l -iname *.sdcard)

echo "Choose image to flash:"
INDEX=1
for img in $IMAGES
do
	echo "$INDEX - $(basename $img)"
	if [[ -z $IMGS ]]
	then
		IMGS="$img"
	else
		IMGS="$IMGS,$img"
	fi
	let INDEX=INDEX+1
done

while true
do
	echo -n "Choice: "
	read c
	
	isn='^[1-9]+$'
	if ! [[ $c =~ $isn ]]
	then
		echo "Input a number"
	else
		break
	fi
done

IMG=$(eval echo $IMGS | cut -d"," -f$c)
echo -n "About to copy [$IMG] to SD card, enter any key "
read foo

sudo dd if=$IMG of=/dev/sdb bs=1M status=progress
