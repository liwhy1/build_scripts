#!/bin/bash
# Sample script by Liwhy

# Clear folders
rm -rf .repo/local_manifests/
rm -rf device/xiaomi/sapphire/

# Init ROM manifest
repo init -u https://github.com/LineageOS/android.git -b lineage-21.0 --git-lfs
echo "=================="
echo "ROM manifest init success"
echo "=================="

# Clone local manifest
git clone https://github.com/Liekoo/local-manifest --depth=1 -b 14 .repo/local_manifests
echo "============================"
echo "Local manifest clone success"
echo "============================"

# Clone additional trees
git clone https://github.com/Liekoo/device_xiaomi_sapphire --depth=1 -b main device/xiaomi/sapphire
echo "============================"
echo "Additional trees clone success"
echo "============================"

# Sync
/opt/crave/resync.sh
echo "============="
echo "Sync success"
echo "============="

# OPTIONAL
# Use AOSP clang for no errors
# rm -r prebuilts/clang/host/linux-x86
# git clone https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 --depth=1 prebuilts/clang/host/linux-x86

# Auto-sign build
# wget https://raw.githubusercontent.com/Trijal08/crDroid-build-signed-script-auto/main/create-signed-env.sh
# chmod a+x create-signed-env.sh
# ./create-signed-env.sh

# Export parameters
export BUILD_USERNAME=User
export BUILD_HOSTNAME=crave
echo "======= Export Done ======"

# Set up build environment
source build/envsetup.sh
lunch lineage_sapphire-ap2a-userdebug
echo "====== Envsetup Done ======="

# Build ROM
make installclean
mka bacon