#!/usr/bin/env bash

# enable debugging
#set -x

apt-get update
apt-get install -y --no-install-recommends \
  screen \
  xubuntu-desktop

user=${1}

if [ $user ]
then
  [ -d /home/$user ] || useradd --create-home --gid vagrant --shell /bin/bash $user
  echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vagrant
fi

timedatectl set-timezone America/Los_Angeles