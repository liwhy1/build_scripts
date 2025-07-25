#!/bin/bash

syncing=false
cwd=$(pwd)

if [ "$syncing" = true ]; then
	# Clear folders
	rm -rf .repo/local_manifests
	rm -rf {device,vendor,kernel}/oplus
	rm -rf vendor/*-priv/keys
	rm -rf prebuilts/*clang*
	rm -rf external/*clang*
	rm -rf external/wpa_supplicant_8
	rm -rf device/mediatek/sepolicy_vndr
	echo "============================="
	echo "Old directory removal finished"
	echo "============================="

	# Init ROM manifest
	repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs
	echo "=========================="
	echo "ROM manifest init finished"
	echo "=========================="

	# Clone local manifest
	git clone https://github.com/liwhy1/local_manifests -b evox-11 .repo/local_manifests
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
rm -rf device/oplus/MT6893/
git clone https://github.com/liwhy1/android_device_oplus_MT6893 -b evox-11 device/oplus/MT6893 --depth=1
#rm -rf vendor/oplus/MT6893/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_MT6893 -b lineage-23 vendor/oplus/MT6893 --depth=1
#rm -rf kernel/oplus/mt6893/
#git clone https://github.com/mt6893-development/android_kernel_oplus_mt6893 -b lineage-22.2 kernel/oplus/mt6893 --depth=1
#rm -rf vendor/oplus/camera/
#git clone https://gitlab.com/liwhy1/proprietary_vendor_oplus_camera -b lineage-22.2 vendor/oplus/camera --depth=1

# Set up build environment
cd $cwd
. build/envsetup.sh

# Build signed
cd $cwd
echo "=============="
echo "Starting build"
echo "=============="
breakfast MT6893 userdebug
#make installclean
#m evolution
m "android.hardware.biometrics.fingerprint@2.3-service.MT6893"

#cd $cwd
#echo "======================="
#echo "Building bootimage only"
#echo "======================="
#rm -rf kernel/oplus/mt6893/
#git clone https://github.com/liwhy1/android_kernel_oplus_mt6893 -b ksu-next-susfs kernel/oplus/mt6893
#. build/envsetup.sh
#mka bootimage
