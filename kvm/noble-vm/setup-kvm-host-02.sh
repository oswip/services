#!/bin/bash
#
# set up a storage pool, which is crucial for certain qemu disk-related activities

STORAGE_POOL_NAME=kpool01

if [ -d "/opt/kvm" ]; then
  echo "found /opt/kvm"
else
  echo "expecting folder /opt/kvm, please create and have write access"
  exit 1
fi


virsh pool-define-as ${STORAGE_POOL_NAME} dir - - - - "/opt/kvm/"
virsh pool-build ${STORAGE_POOL_NAME}
virsh pool-start ${STORAGE_POOL_NAME}
virsh pool-autostart ${STORAGE_POOL_NAME}

virsh pool-list

virsh pool-info ${STORAGE_POOL_NAME}

