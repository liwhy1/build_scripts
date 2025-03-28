#!/bin/bash

syncing=false
cwd=$(pwd)

if [ "$syncing" = true ]; then
	# Clear folders
	rm -rf .repo/local_manifests/
	rm -rf device/oplus/denniz/
	rm -rf device/oplus/mt6893-common/
	rm -rf vendor/oplus/denniz/
	rm -rf vendor/oplus/mt6893-common/
	rm -rf vendor/evolution-priv/keys/
	rm -rf vendor/lineage-priv/keys/
	rm -rf kernel/oplus/mt6893/
	rm -rf device/oplus/camera/
	rm -rf hardware/oplus
	rm -rf prebuilts/clang/host/linux-x86/
	echo "============================="
	echo "Old directory remove finished"
	echo "============================="

	# Init ROM manifest
	repo init -u https://github.com/Evolution-X/manifest -b vic-qpr1 --git-lfs
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
git clone https://github.com/liwhy1/android_device_oplus_mt6893-common -b lineage-22.1 device/oplus/mt6893-common
#rm -rf kernel/oplus/mt6893-common/
#git clone https://github.com/Kingslayer9988/android_kernel_oplus_mt6893 -b kingslayer kernel/oplus/mt6893
#rm -rf vendor/oplus/denniz/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_denniz -b lineage-21_wip vendor/oplus/denniz
#rm -rf vendor/oplus/mt6893-common/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_mt6893-common -b lineage-22.1_wip vendor/oplus/mt6893-common
rm -rf device/oplus/camera/
git clone https://gitlab.com/liwhy1/android_device_oplus_camera -b lineage-22.1_wip device/oplus/camera
#rm -rf hardware/oplus/
#git clone https://github.com/liwhy1/hardware_oplus -b vic hardware/oplus

# Set up build environment
cd $cwd
. build/envsetup.sh
echo "================="
echo "Envsetup finished"
echo "================="

# Build signed
cd $cwd
echo "=============="
echo "Starting build"
echo "=============="
breakfast denniz userdebug
make installclean
m evolution
