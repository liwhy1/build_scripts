#!/bin/bash

syncing=true
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
	git clone https://github.com/liwhy1/local_manifests -b lineage-22.1 .repo/local_manifests
	echo "============================="
	echo "Local manifest clone finished"
	echo "============================="

	# Clone signing keys
	git clone https://github.com/liwhy1/build_scripts -b lineage_keys vendor/lineage-priv/keys
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
rm -rf kernel/oplus/mt6893
git clone https://github.com/liwhy1/android_kernel_oplus_mt6893 -b kernelsu-next kernel/oplus/mt6893

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
mka bacon
mka bootimage

# Build non ksu boot image
cd $cwd
echo "======================="
echo "Building bootimage only"
echo "======================="
rm -rf kernel/oplus/mt6893/
git clone https://github.com/liwhy1/android_kernel_oplus_mt6893 -b lineage-22.1 kernel/oplus/mt6893
breakfast denniz userdebug
mka bootimage
