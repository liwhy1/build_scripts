#!/bin/bash

syncing=false
cwd=$(pwd)

if [ "$syncing" = true ]; then
	# Clear folders
	rm -rf .repo/local_manifests
	rm -rf {device,vendor,kernel}/oplus
	rm -rf vendor/*-priv/keys
	echo "============================="
	echo "Old directory removal finished"
	echo "============================="

	# Init ROM manifest
	repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs
	echo "=========================="
	echo "ROM manifest init finished"
	echo "=========================="

	# Clone local manifest
	git clone https://github.com/liwhy1/local_manifests -b evox-10 .repo/local_manifests
	echo "============================="
	echo "Local manifest clone finished"
	echo "============================="

	# Clone signing keys
	git clone https://github.com/liwhy1/build_scripts -b evolution_keys vendor/evolution-priv/keys
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
rm -rf device/oplus/mt6893-common/
git clone https://github.com/liwhy1/android_device_oplus_mt6893-common -b lineage-22.2 device/oplus/mt6893-common
rm -rf device/oplus/denniz/
git clone https://github.com/liwhy1/android_device_oplus_denniz -b evox-10 device/oplus/denniz
#rm -rf vendor/oplus/denniz/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_denniz -b lineage-22.2_cam vendor/oplus/denniz
#rm -rf vendor/oplus/mt6893-common/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_mt6893-common -b lineage-22.2_wip vendor/oplus/mt6893-common
#rm -rf kernel/oplus/mt6893/
#git clone https://github.com/mt6893-development/android_kernel_oplus_mt6893 -b lineage-23 kernel/oplus/mt6893 --depth=1
rm -rf vendor/oplus/camera/
git clone https://gitlab.com/liwhy1/proprietary_vendor_oplus_camera -b lineage-22.2 vendor/oplus/camera

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
m evolution

#cd $cwd
#echo "======================="
#echo "Building bootimage only"
#echo "======================="
#rm -rf kernel/oplus/mt6893/
#git clone https://github.com/liwhy1/android_kernel_oplus_mt6893 -b ksu-next-susfs kernel/oplus/mt6893
#. build/envsetup.sh
#mka bootimage
