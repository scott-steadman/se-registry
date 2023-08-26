#!/bin/bash

set -x

export DISPLAY=localhost:10.0

~/Android/Sdk/emulator/emulator \
  -avd Pixel_4a_Android_13 \
  -gpu swiftshader_indirect \
  -grpc \
  -verbose \
  -show-kernel \
  -no-snapshot-load