#!/bin/bash

# Vars
sync=true
sign=false
cwd=$(pwd)

if [ "$sync" = true ]; then
	# Clear folders
	echo "=========================="
	echo "Removing old directories.."
	echo "=========================="
	rm -rf .repo/local_manifests
	rm -rf {device,vendor,kernel}/oplus
	rm -rf vendor/*-priv/keys
	rm -rf prebuilts/*clang*
	rm -rf external/*clang*

	# Init ROM manifest
	echo "==========================="
	echo "Initializing ROM manifest.."
	echo "==========================="
	repo init -u https://github.com/Evolution-X/manifest -b bq2 --git-lfs

	# Clone local manifest
	echo "========================"
	echo "Cloning local manifest.."
	echo "========================"
	git clone https://github.com/liwhy1/local_manifests -b evox-11 .repo/local_manifests --depth=1

	# Clone signing keys
	if [ "$sign" = true ]; then
		echo "======================"
		echo "Cloning signing keys.."
		echo "======================"
		git clone https://github.com/liwhy1/build_scripts -b evolution_keys vendor/evolution-priv/keys --depth=1
	else
		echo "=================="
		echo "Skipping signing.."
		echo "=================="
	fi

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
rm -rf device/oplus/MT6893/
git clone https://github.com/liwhy1/android_device_oplus_op6893 -b evox-11_wip device/oplus/op6893 --depth=1
#rm -rf vendor/oplus/MT6893/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_MT6893 -b lineage-23 vendor/oplus/MT6893 --depth=1
#rm -rf kernel/oplus/mt6893/
#git clone https://github.com/mt6893-development/android_kernel_oplus_mt6893 -b lineage-22.2 kernel/oplus/mt6893 --depth=1
#rm -rf vendor/oplus/camera/
#git clone https://gitlab.com/liwhy1/proprietary_vendor_oplus_camera -b main vendor/oplus/camera --depth 1
rm -rf vendor/oplus/camera
rm -rf device/oplus/op6893/vendorsetup.sh

# Set up build environment
cd $cwd
. build/envsetup.sh
breakfast op6893 userdebug

# Start build
echo "================"
echo "Starting build.."
echo "================"
cd $cwd
m installclean
m evolution