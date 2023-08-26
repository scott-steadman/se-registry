#!/bin/bash

# Priorities:
#   V: Verbose (lowest priority)
#   D: Debug
#   I: Info
#   W: Warning
#   E: Error
#   F: Fatal
#   S: Silent (highest priority, where nothing is ever printed)

~/Android/Sdk/platform-tools/adb logcat \
  ActivityManager:I \
  e.gift_registry:V \
  flutter:V \
  *:S
