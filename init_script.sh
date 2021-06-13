#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

apt-get -y update
apt-get -y dist-upgrade
apt-get -y clean
sync

echo "custom init script completed" > /var/log/init_script.log
