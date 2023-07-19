#!/usr/bin/env bash

sdk_dir=~/Android/Sdk

# enable debugging
set -x

# abort on error
#set -e

#sudo yum install -y \
#  google-chrome-stable

# rm 
#  java-1.8.0-openjdk-headless
#  java-1.8.0-openjdk

# Install Android Studio
if [ ! -d ~/android-studio ] 
then
  echo Installing Android Studio (Use Android Studio to install the SDK)
  curl -sL 'https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.20/android-studio-2022.2.1.20-linux.tar.gz' | \
    tar -C ~ -xvzf -
fi

# Install flutter
if [ ! -d ~/flutter ]
then
  curl -sL 'https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.6-stable.tar.xz' | \
    tar -C ~ -xvf -
fi