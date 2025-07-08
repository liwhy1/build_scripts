#!/bin/bash

syncing=false
cwd=$(pwd)

if [ "$syncing" = true ]; then
	# Clear folders
	rm -rf .repo/local_manifests
	rm -rf {device,vendor,kernel}/oplus
	rm -rf vendor/*-priv/keys
	echo "============================="
	echo "Old directory remove finished"
	echo "============================="

	# Init ROM manifest
	repo init -u https://github.com/LineageOS/android.git -b lineage-22.2 --git-lfs
	echo "=========================="
	echo "ROM manifest init finished"
	echo "=========================="

	# Clone local manifest
	git clone https://github.com/liwhy1/local_manifests -b lineage-22.2 .repo/local_manifests --depth 1
	echo "============================="
	echo "Local manifest clone finished"
	echo "============================="

	# Clone signing keys
	git clone https://github.com/liwhy1/build_scripts -b lineage_keys vendor/lineage-priv/keys --depth 1
	echo "==========================="
	echo "Signing keys clone finished"
	echo "==========================="

	# Sync
	/opt/crave/resync.sh
	echo "============="
	echo "Sync finished"
	echo "============="
else
	echo "============="
	echo "Skipping sync"
	echo "============="
fi

# Clone WIP trees
#rm -rf device/oplus/mt6893-common/
#git clone https://github.com/liwhy1/android_device_oplus_mt6893-common -b lineage-22.2_wip device/oplus/mt6893-common --depth 1
rm -rf device/oplus/denniz/
git clone https://github.com/liwhy1/android_device_oplus_denniz -b lineage-22.2 device/oplus/denniz --depth 1
#rm -rf vendor/oplus/denniz/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_denniz -b lineage-22.2 vendor/oplus/denniz --depth 1
#rm -rf vendor/oplus/mt6893-common/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_mt6893-common -b lineage-22.2_wip vendor/oplus/mt6893-common --depth 1
#rm -rf kernel/oplus/mt6893/
#git clone https://github.com/mt6893-development/android_kernel_oplus_mt6893 -b lineage-22.2 kernel/oplus/mt6893 --depth 1
#rm -rf vendor/oplus/camera
#git clone https://gitlab.com/liwhy1/proprietary_vendor_oplus_camera -b lineage-22.1_wip vendor/oplus/camera --depth 1

# WPA3 fix
#rm -rf external/wpa_supplicant_8
#git clone https://github.com/LineageOS/android_external_wpa_supplicant_8 external/wpa_supplicant_8 --depth 1
#cd external/wpa_supplicant_8
#git fetch https://github.com/Adarsh0127-Elite/android_external_wpa_supplicant_8 252a7ddfdeab428bcb78c7f1dd170db814ee7687
#git cherry-pick 252a7ddfdeab428bcb78c7f1dd170db814ee7687

rm -rf prebuilts/clang/host/linux-x86/clang-r487747c

# Set up build environment
cd $cwd
. build/envsetup.sh

# Build signed
cd $cwd
echo "=============="
echo "Starting build"
echo "=============="
breakfast denniz userdebug
make installclean
mka bacon

# Build secondary boot image
#cd $cwd
#echo "======================="
#echo "Building bootimage only"
#echo "======================="
#rm -rf kernel/oplus/mt6893/
#git clone https://github.com/liwhy1/android_kernel_oplus_mt6893 -b ksu_next_susfs kernel/oplus/mt6893
#. build/envsetup.sh
#mka bootimage
