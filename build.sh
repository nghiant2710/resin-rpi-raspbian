#!/bin/bash

set -o errexit

SUITES='wheezy'
MIRROR='http://mirror.nus.edu.sg/raspbian/raspbian/'
REPO='nghiant2710/stock-image'
LATEST='jessie'

curl -SLO https://github.com/nghiant2710/qemu/releases/download/$QEMU_VERSION/qemu-$QEMU_VERSION.tar.gz \
	&& echo "$QEMU_SHA256  qemu-$QEMU_VERSION.tar.gz" > qemu-$QEMU_VERSION.tar.gz.sha256sum \
	&& sha256sum -c qemu-$QEMU_VERSION.tar.gz.sha256sum \
	&& tar -xz --strip-components=1 -f qemu-$QEMU_VERSION.tar.gz

for suite in $SUITES; do
	dir=$(mktemp --tmpdir=/var/tmp -d)
	date=$(date +'%Y%m%d' -u)
	
	mkdir -p $dir/rootfs/usr/bin
	cp qemu-arm-static $dir/rootfs/usr/bin
	chmod +x $dir/rootfs/usr/bin/qemu-arm-static
	
	./mkimage.sh -t $REPO:$suite --dir=$dir debootstrap --verbose --foreign --variant=minbase --keyring=/root/.gnupg/pubring.gpg --arch=armhf --include=sudo $suite $MIRROR
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
