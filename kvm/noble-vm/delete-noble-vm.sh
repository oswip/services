#!/bin/bash
#

VM_HOSTNAME=dev01
IMAGE_SUBDIR=cloud_images
BASE_IMAGE=noble-server-cloudimg-amd64.img
PROVISIONED_IMAGE=noble-server-amd64.qcow2
CLOUD_INIT_IMAGE=cloud-init-provisioning.qcow2

virsh destroy ${VM_HOSTNAME}

sleep 2

virsh undefine ${VM_HOSTNAME}

rm -f ${IMAGE_SUBDIR}/cloud-init-provisioning.qcow2

