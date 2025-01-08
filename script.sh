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
#repo init -u https://github.com/RisingTechOSS/android -b fifteen --git-lfs
#echo "========================="
#echo "ROM manifest init success"
#echo "========================="

# Clone local manifest
git clone https://github.com/liwhy1/local_manifests -b rising-6 .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Sync
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# Set up build environment
cd $cwd
. build/envsetup.sh
echo "============="
echo "Envsetup Done"
echo "============="

# Build signed
git clone https://github.com/liwhy1/build_scripts -b rising_keys vendor/lineage-priv/keys
riseup denniz userdebug
rise sb
