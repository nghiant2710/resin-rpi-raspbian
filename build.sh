#!/bin/bash

set -o errexit

SUITES='jessie'
MIRROR='http://archive.raspbian.org/raspbian'
REPO='nghiant2710/stock-image'
LATEST='jessie'

for suite in $SUITES; do
	dir=$(mktemp --tmpdir=/var/tmp -d)
	date=$(date +'%Y%m%d' -u)
	
	mkdir -p $dir/rootfs/usr/bin
	cp qemu-arm-static $dir/rootfs/usr/bin
	chmod +x $dir/rootfs/usr/bin/qemu-arm-static
	
	./mkimage.sh -t $REPO:$suite --dir=$dir debootstrap --keyring=/root/.gnupg/pubring.gpg --arch=armhf --include=sudo $suite $MIRROR
	rm -rf $dir

	#docker run --rm $REPO:$suite bash -c 'dpkg-query -l' > $suite

	# Upload to S3 (using AWS CLI)
	#printf "$ACCESS_KEY\n$SECRET_KEY\n$REGION_NAME\n\n" | aws configure
	#aws s3 cp $suite s3://$BUCKET_NAME/image_info/rpi-raspbian/$suite/
	#aws s3 cp $suite s3://$BUCKET_NAME/image_info/rpi-raspbian/$suite/$suite_$date
	#rm -f $suite 

	#docker tag -f $REPO:$suite $REPO:$suite-$date
	#if [ $LATEST == $suite ]; then
	#	docker tag -f $REPO:$suite $REPO:latest
	#fi
done
