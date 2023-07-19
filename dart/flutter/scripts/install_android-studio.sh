#!/usr/bin/env bash

sdk_dir=~/Android/Sdk

# enable debugging
#set -x

# abort on error
#set -e

# Install required packages
sudo apt-get install -y \
  fonts-liberation \
  lib32z1 \
  openjdk-11-jdk

[ -f /tmp/chrome.deb ] || wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O /tmp/chrome.deb 
[ -f /usr/bin/google-chrome ] || sudo dpkg -i /tmp/chrome.deb

# Install Android Studio
[ -f /tmp/android-studio.tgz ] || wget https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2022.2.1.20/android-studio-2022.2.1.20-linux.tar.gz -O /tmp/android-studio.tgz
[ -d ~/android-studio ] || tar xvzf /tmp/android-studio.tgz

#Install flutter
[ -d ~/snap ] || sudo snap install flutter --classic

# Install Android SDK
[ -f /tmp/sdk.zip ] || curl https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip >/tmp/sdk.zip

mkdir -p $sdk_dir
export ANDROID_HOME=$sdk_dir
export PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/bin

if [ ! -d $sdk_dir/cmdline-tools ] 
then
  unzip -d $sdk_dir /tmp/sdk.zip
  yes | sdkmanager --licenses --sdk_root=$ANDROID_HOME
  sdkmanager --install "cmdline-tools;latest" --sdk_root=$ANDROID_HOME

cat <<- EOT >>~/.bashrc

# Added by $0
export ANDROID_HOME=$sdk_dir
export PATH=\${PATH}:\${ANDROID_HOME}/cmdline-tools/bin
EOT

fi
