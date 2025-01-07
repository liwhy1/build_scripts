#!/bin/bash

# Clear folders
cwd=$(pwd)
rm -rf .repo/local_manifests/
rm -rf device/oplus/denniz/
rm -rf device/oplus/mt6893-common/
rm -rf vendor/oplus/denniz/
rm -rf vendor/oplus/mt6893-common/
rm -rf vendor/lineage-priv/keys/
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

rm -rf device/oplus/denniz/
git clone https://github.com/liwhy1/android_device_oplus_denniz -b lineage-22.1 device/oplus/denniz

# Set up build environment
. build/envsetup.sh
echo "============="
echo "Envsetup Done"
echo "============="
cd $cwd

# Build signed
git clone https://github.com/liwhy1/build_scripts -b lineage_keys $cwd/vendor/lineage-priv/keys
lunch lineage_denniz-ap3a-userdebug 
breakfast denniz userdebug
mka bacon
