#!/bin/bash
#

KVM_USER=${1}

if [ -z "${KVM_USER}" ]
  then
    echo "No user specified, selecting user:user"
    KVM_USER=user
fi


echo "About to kvm for username:${KVM_USER}, cancel if it's wrong"

sleep 5

sudo apt install -y qemu-system libvirt-daemon libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager bridge-utils cpu-checker cloud-image-utils

sudo usermod -aG libvirt ${KVM_USER}
sudo usermod -aG kvm ${KVM_USER}

sudo systemctl status libvirtd

echo "you should log out and log back in to get access to kvm"


