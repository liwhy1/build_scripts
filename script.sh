#!/bin/bash

# Clear folders
cwd=$(pwd)
rm -rf .repo/local_manifests/
rm -rf device/oplus/denniz/
rm -rf device/oplus/mt6893-common/
rm -rf vendor/oplus/denniz/
rm -rf vendor/oplus/mt6893-common/
rm -rf kernel/oplus/mt6893-common/
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

# Clone wip trees
rm -rf kernel/oplus/mt6893/
git clone https://github.com/liwhy1/android_kernel_oplus_mt6893 -b kingslayer kernel/oplus/mt6893

# Set up build environment
cd $cwd
. build/envsetup.sh
echo "============="
echo "Envsetup Done"
echo "============="

# Double check if ksu was initialized succesfully and handle it in case of an error
KSU="kernel/oplus/mt6893/KernelSU"
if [ ! -d "$KSU" ]; then
    git clone https://github.com/rifsxd/KernelSU-Next -b next kernel/oplus/mt6893/KernelSU
fi

# Build signed
cd $cwd
git clone https://github.com/liwhy1/build_scripts -b lineage_keys vendor/lineage-priv/keys
breakfast denniz userdebug
mka bacon
