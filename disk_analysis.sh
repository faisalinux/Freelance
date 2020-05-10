#!/bin/bash
if [ -f $1 ]; then
filepath=$1 && echo "the image file provided as argument $filepath"
read -p "the mount point for it  press ENTER to selet default : " mountpoint

#check file exist
if test -f "$filepath"; then
    echo "$filepath exist took argument"
	#check mount point exist
	if [ -d "$mountpoint" ]; then
        echo "$mountpoint exist"
	else echo "$mountpoint doesnot exist"
	echo "creating $mountpoint"
	mkdir $mountpoint
	fi

	#check existing mount mountpoint is empty
	if    ls -1qA $mountpoint | grep -q .
	then  ! echo "$mountpoint is not empty" 
	exit
	else  echo "$mountpoint is empty"
	fi

	mount -o ro,loop,offset=1048576 $filepath $mountpoint
	#echo "removing old filedata if any" && rm filedata.txt
	ls -l $mountpoint/bin/* | awk '{if(NR==1){print "Filename,Modifecationdate,size,Owner,Group,uid,permission";}else{print $9 "," $7"-"$6"-"$8 "," $5 "," $4 "," $3 "," $2 "," $1;}}'> bindata.txt
	ls -l $mountpoint/sbin/* | awk '{print $9 "," $7"-"$6"-"$8 "," $5 "," $4 "," $3 "," $2 "," $1;}'> sbindata.txt
	cat bindata.txt sbindata.txt > filedata.txt
	echo "removing old file bindata if any" &&  rm bindata.txt 
	echo "removing old file sbindata if any" && rm sbindata.txt
	echo "unmounting image file" && umount $mountpoint
	###########################
exit

else
read -p "enter image file with complete path : " filepathone
read -p "the mount point for it  press ENTER to selet default : " mountpoint
echo $filepathone
echo $filepath
filepath=$filepathone
#check file exist
	if test -f "$filepath"; then
	echo "$filepath exist"
	else echo "******no file to mount exist"
	exit
	fi

	#check mount point exist
	if [ -d "$mountpoint" ]; then
	echo "$mountpoint exist"
	else echo "$mountpoint doesnot exist"
	echo "creating $mountpoint"
	mkdir $mountpoint
	fi

	#check existing mount mountpoint is empty
	if    ls -1qA $mountpoint | grep -q .
	then  ! echo "$mountpoint is not empty" 
	exit
	else  echo "$mountpoint is empty"
	fi

mount -o ro,loop,offset=1048576 $filepath $mountpoint && echo "mounting"
rm filedata.txt
ls -l $mountpoint/bin/* | awk '{if(NR==1){print "Filename,Modifecationdate,size,Owner,Group,uid,permission";}else{print $9 "," $7"-"$6"-"$8 "," $5 "," $4 "," $3 "," $2 "," $1;}}'> bindata.txt
ls -l $mountpoint/sbin/* | awk '{print $9 "," $7"-"$6"-"$8 "," $5 "," $4 "," $3 "," $2 "," $1;}'> sbindata.txt
cat bindata.txt sbindata.txt > filedata.txt
rm bindata.txt 
rm sbindata.txt
echo "unmounting image file" && umount "$mountpoint"
fi
