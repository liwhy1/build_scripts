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
	repo init -u https://github.com/Evolution-X/manifest -b vic --git-lfs
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
#rm -rf device/oplus/mt6893-common/
#git clone https://github.com/liwhy1/android_device_oplus_mt6893-common -b lineage-22.1_wip1 device/oplus/mt6893-common
#rm -rf device/oplus/denniz/
#git clone https://github.com/liwhy1/android_device_oplus_denniz -b evox-10 device/oplus/denniz
#rm -rf hardware/mediatek/
#git clone https://github.com/liwhy1/android_hardware_mediatek -b lineage-22.1 hardware/mediatek
rm -rf kernel/oplus/mt6893
git clone https://github.com/dek0der/kernel_realme_RMX3031 -b KSU-Next-SUSFS kernel/oplus/mt6893
#rm -rf vendor/oplus/denniz/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_denniz -b lineage-21_wip vendor/oplus/denniz
#rm -rf vendor/oplus/mt6893-common/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_mt6893-common -b lineage-22.1 vendor/oplus/mt6893-common

# Patch fsgen to fix conflicting lib issue
sed -i '/soong_filesystem_creator {/,/}/s/enabled: true/enabled: false/' build/soong/fsgen/Android.bp
echo "===================="
echo "Fsgen patch finished"
echo "===================="

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
