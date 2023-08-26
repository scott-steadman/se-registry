#!/bin/bash

# From: https://www.codesiri.com/2022/10/flutter-dart-error-can-t-load-kernel-binary-Invalid-kernel-binary.html

set -x

flutter clean
flutter pub get 

#rm -rf ~/flutter/bin/cache

#flutter doctor