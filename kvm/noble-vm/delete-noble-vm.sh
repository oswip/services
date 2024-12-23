#!/bin/bash
#

VM_HOSTNAME=dev01
CLOUD_IMAGES_DIR=/opt/kvm/cloud_images
BASE_IMAGE=noble-server-cloudimg-amd64.img
PROVISIONED_IMAGE=noble-server-amd64.qcow2
CLOUD_INIT_IMAGE=cloud-init-provisioning.qcow2

virsh destroy ${VM_HOSTNAME}

sleep 2

virsh undefine ${VM_HOSTNAME}

rm -f ${CLOUD_IMAGES_DIR}/cloud-init-provisioning.qcow2

if [ -z "${1}" ]; then
  echo "to completely wipe the noble-server-amd64.qcow2, run ${0} full"
else 
  rm -f ${CLOUD_IMAGES_DIR}/noble-server-amd64.qcow2
fi 

