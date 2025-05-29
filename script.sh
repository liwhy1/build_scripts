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
#git clone https://github.com/liwhy1/android_device_oplus_mt6893-common -b lineage-22.2 device/oplus/mt6893-common
#rm -rf device/oplus/denniz/
#git clone https://github.com/liwhy1/android_device_oplus_denniz -b evox-10 device/oplus/denniz
#rm -rf vendor/oplus/denniz/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_denniz -b lineage-22.2_cam vendor/oplus/denniz
#rm -rf vendor/oplus/mt6893-common/
#git clone https://github.com/liwhy1/proprietary_vendor_oplus_mt6893-common -b lineage-22.2 vendor/oplus/mt6893-common
#rm -rf kernel/oplus/mt6893/
#git clone http://github.com/dek0der/kernel_realme_RMX3031 -b KSU-Next-SUSFS kernel/oplus/mt6893

# Set up build environment
cd $cwd
. build/envsetup.sh

# Kernel patch #1
if grep -Fxq 'bool ksu_devpts_hook = false;' kernel/oplus/mt6893/KernelSU-Next/kernel/sucompat.c; then
  echo "Kernel patch #1 already applied."
else
  if grep -Fxq 'extern bool ksu_su_compat_enabled;' kernel/oplus/mt6893/KernelSU-Next/kernel/sucompat.c; then
    sed -i '/^extern bool ksu_su_compat_enabled;$/a bool ksu_devpts_hook = false;' kernel/oplus/mt6893/KernelSU-Next/kernel/sucompat.c
    echo "Kernel patch #1 applied."
  else
    echo "Kernel patch #1 failed."
  fi
fi

# Kernel patch #2
if grep -Fxq 'extern bool susfs_is_sus_su_hooks_enabled __read_mostly;' kernel/oplus/mt6893/fs/susfs.c; then
  echo "Kernel patch #2 already applied."
else
  sed -i 's/^bool susfs_is_sus_su_hooks_enabled __read_mostly = false;$/extern bool susfs_is_sus_su_hooks_enabled __read_mostly;/' kernel/oplus/mt6893/fs/susfs.c
  echo "Kernel patch #2 applied."
fi

# Build signed
cd $cwd
echo "=============="
echo "Starting build"
echo "=============="
breakfast denniz userdebug
make installclean
m evolution