#!/bin/bash

QEMU_VERSION='2.5.0-resin'
QEMU_SHA256='2e92a1bf9a912db150da2b9b8875ef8ed7ec6a2c476063b448b90cc7327ad430'

# Jenkins build steps
docker build -t raspbian-mkimage .
docker run --privileged -e QEMU_SHA256=$QEMU_SHA256 -e QEMU_VERSION=$QEMU_VERSION -e REGION_NAME=$REGION_NAME -e ACCESS_KEY=$ACCESS_KEY -e SECRET_KEY=$SECRET_KEY -e BUCKET_NAME=$BUCKET_NAME -v /var/run/docker.sock:/var/run/docker.sock raspbian-mkimage
#docker push resin/rpi-raspbian
