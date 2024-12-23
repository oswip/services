#!/bin/bash
#
#
#


VM_HOSTNAME=dev01
CLOUD_IMAGES_DIR=/opt/kvm/cloud_images
WORKING_DIR=${PWD}
BASE_IMAGE=noble-server-cloudimg-amd64.img
BASE_IMAGE_SOURCE_URL=https://cloud-images.ubuntu.com/noble/20241210/noble-server-cloudimg-amd64.img
PROVISIONED_IMAGE=noble-server-amd64.qcow2
CLOUD_INIT_IMAGE=cloud-init-provisioning.qcow2
PROVISIONED_IMAGE_SIZE=20G
KVM_BRIDGE=virbr0


# make sure there are no TODOs in the user-data of cloud-init
todos=$(cat cloud-init/user-data | grep "TODO_")
if [ -z "${todos}" ]; then
  echo "Proceeding with provision"
else
  echo "There are TODO items in cloud-init/user-data, please resolve before provisioning"
  exit 1
fi

# resize the BASE_IMAGE to PROVISIONED_IMAGE_SIZE
pushd ${CLOUD_IMAGES_DIR}
if [ -f "${BASE_IMAGE}" ]; then
  echo "Found ${BASE_IMAGE}"
else
  wget ${BASE_IMAGE_SOURCE_URL}
fi

qemu-img create -f qcow2 -F qcow2 -b ${BASE_IMAGE} ${PROVISIONED_IMAGE} ${PROVISIONED_IMAGE_SIZE}
qemu-img info ${PROVISIONED_IMAGE}
popd
sleep 5

# create a disk image that contains the cloudinit provisioning
pushd cloud-init
cloud-localds -v --network-config=network-config ${CLOUD_INIT_IMAGE} user-data meta-data
mv ${CLOUD_INIT_IMAGE} ${CLOUD_IMAGES_DIR}/
popd

# create the vm
virt-install \
  --name ${VM_HOSTNAME} \
  --virt-type kvm \
  --vcpus 42 \
  --memory 6144 \
  --disk path=${CLOUD_IMAGES_DIR}/${PROVISIONED_IMAGE},device=disk \
  --disk path=${CLOUD_IMAGES_DIR}/${CLOUD_INIT_IMAGE},device=cdrom \
  --os-variant ubuntu24.04 \
  --graphics none \
  --sound none \
  --network bridge=${KVM_BRIDGE} \
  --import

echo "to hide the console, add the [--autoconsole none] argument to the virt-install command"

#echo "waiting for machine to boot before attaching assets.iso"
#echo "to see the console, remove the [--autoconsole none] argument from virt-install"
#sleep 45


# share any assets with the guest vm using an iso
#genisoimage -o assets.iso -r assets
#virsh attach-disk dev01 $PWD/assets.iso sda --type cdrom --mode readonly

