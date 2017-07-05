#!/bin/bash

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
echo -n "About to copy [$IMG] to NFS server, enter any key "
read foo


echo "Extracting rootfs ($(eval echo $IMG | sed -e 's/sdcard/tar\.bz2/g'))"
sudo tar xjf "$(eval echo $IMG | sed -e 's/sdcard/tar\.bz2/g')" -C /nfs-server/

while true
do
	echo -n "Copy zImage over SSH? (y/n)"
	read ans
	case $ans in
		y|Y)
			echo "Under implementation..."
			;;
		n|N|"")
			echo "Skipping ..."
			break
			;;
		*)
			echo "Bad option \"$ans\""
			;;
	esac
done

while true
do
        echo -n "Copy dtb over SSH? (y/n)"
        read ans
        case $ans in
                y|Y)
                        echo "Under implementation..."
                        ;;
                n|N|"")
                        echo "Skipping ..."
                        break
                        ;;
                *)
                        echo "Bad option \"$ans\""
                        ;;
        esac
done

CODE="$?"
echo "Done"
exit $CODE
