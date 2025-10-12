#!/bin/bash

syncing=true
cwd=$(pwd)

if [ "$syncing" = true ]; then
	# Clear folders
	echo "=========================="
	echo "Removing old directories.."
	echo "=========================="
	rm -rf .repo/local_manifests
	rm -rf {device,vendor,kernel}/oplus
	rm -rf vendor/*-priv/keys
	rm -rf prebuilts/*clang*
	rm -rf external/*clang*
	rm -rf external/wpa_supplicant_8
	rm -rf device/mediatek/sepolicy_vndr

	# Init ROM manifest
	echo "==========================="
	echo "Initializing ROM manifest.."
	echo "==========================="
	repo init -u https://github.com/LineageOS/android.git -b lineage-23.0 --git-lfs

	# Clone local manifest
	echo "========================"
	echo "Cloning local manifest.."
	echo "========================"
	git clone https://github.com/liwhy1/local_manifests -b lineage-23 .repo/local_manifests --depth=1

	# Clone signing keys
	echo "======================"
	echo "Cloning signing keys.."
	echo "======================"
	git clone https://github.com/liwhy1/build_scripts -b lineage_keys vendor/lineage-priv/keys --depth=1

	# Sync
	echo "============================"
	echo "Synchronizing repositories.."
	echo "============================"
	/opt/crave/resync.sh

else
	echo "==============="
	echo "Skipping sync.."
	echo "==============="
fi

# Clone WIP trees
#rm -rf device/oplus/MT6893/
#git clone https://github.com/liwhy1/android_device_oplus_MT6893 -b lineage-23 device/oplus/MT6893 --depth=1
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
echo "================"
echo "Starting build.."
echo "================"
cd $cwd
breakfast MT6893 userdebug
make installclean
mka bacon

#cd $cwd
#echo "========================="
#echo "Building bootimage only.."
#echo "========================="
#rm -rf kernel/oplus/mt6893/
#git clone https://github.com/liwhy1/android_kernel_oplus_mt6893 -b ksu-next-susfs kernel/oplus/mt6893
#. build/envsetup.sh
#mka bootimage
