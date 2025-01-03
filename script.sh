#!/bin/bash

# Clear folders
rm -rf .repo/local_manifests
rm -rf device/oplus/denniz
rm -rf device/oplus/mt6893-common
rm -rf vendor/oplus/denniz
rm -rf vendor/oplus/mt6893-common
echo "======================="
echo "Old directories removed"
echo "======================="

# Init ROM manifest
repo init -u https://github.com/LineageOS/android.git -b lineage-22.1 --git-lfs
echo "========================="
echo "ROM manifest init success"
echo "========================="

# Clone local manifest
git clone https://github.com/liwhy1/local_manifests -b lineage-22.1 .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Export parameters
export BUILD_USERNAME=Liwhy
export BUILD_HOSTNAME=crave
echo "============"
echo "Export Done"
echo "============"

# Set up build environment
source build/envsetup.sh
echo "============="
echo "Envsetup Done"
echo "============="

# Build signed ROM
breakfast denniz userdebug; \
mka target-files-package otatools; \
/opt/crave/crave_sign.sh