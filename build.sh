#!/bin/bash

echo "****Start building****"
echo "****Cleaning****"

make clean
make mrproper
rm output/kernel/zImage
rm output/system/lib/modules/msm-buspm-dev.ko
rm output/system/lib/modules/kineto_gan.ko
rm output/system/lib/modules/bcmdhd.ko
rm output/system/lib/modules/sequans_sdio.ko
rm output/system/lib/modules/spidev.ko
rm output/*.zip

START=$(date +%s)
echo "****Building****"

make shooter_defconfig
make -j9 CROSS_COMPILE=/home/michaelc/android/android-toolchain-eabi-12-11/bin/arm-eabi-

echo "****Creating boot image****"
mkdir output/system
mkdir output/system/lib
mkdir output/system/lib/modules
cp arch/arm/boot/zImage output/kernel/zImage
cp drivers/net/wimax/SQN/sequans_sdio.ko output/system/lib/modules/sequans_sdio.ko
cp drivers/net/kineto_gan.ko output/system/lib/modules/kineto_gan.ko
cp drivers/net/wireless/bcmdhd/bcmdhd.ko output/system/lib/modules/bcmdhd.ko
cp drivers/spi/spidev.ko output/system/lib/modules/spidev.ko
cp arch/arm/mach-msm/msm-buspm-dev.ko output/system/lib/modules/msm-buspm-dev.ko
cd output
zip -q -r DIRT-MOD-Kernel-SHOOTER-$(date +"%Y%m%d").zip .

echo "****Compile done****"
echo "****Kernel and modules are in output/****"
END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
read -n 1 -p "Press any key to continue"
