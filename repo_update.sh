#!/bin/bash

# Some people require insecure proxies
HTTP=https
if [ "$INSECURE_PROXY" = "TRUE" ]; then
    HTTP=http
fi

ANDROOT=$PWD

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

pushd $ANDROOT/.repo/local_manifests
git pull
popd

repo sync -j8

pushd $ANDROOT/bionic
LINK=$HTTP && LINK+="://android.googlesource.com/platform/bionic"
git fetch $LINK refs/changes/53/363153/1 && git cherry-pick FETCH_HEAD #Add kryo support.
git fetch $LINK refs/changes/92/368092/2 && git cherry-pick FETCH_HEAD # libc: use Cortex-A7/A53 memset on Kryo
git fetch $LINK refs/changes/14/265214/21 && git cherry-pick FETCH_HEAD # libc: ARM: Add 32-bit Kryo memcpy
git fetch $LINK refs/changes/90/497890/1 && git cherry-pick FETCH_HEAD #libc: add /odm/bin to the DEFPATH
git fetch $LINK refs/changes/91/497891/2 && git cherry-pick FETCH_HEAD # linker: add support for odm partition
popd

pushd $ANDROOT/build/soong
LINK=$HTTP && LINK+="://android.googlesource.com/platform/build/soong"
git fetch $LINK refs/changes/54/266354/28 && git cherry-pick FETCH_HEAD # Add support for an armv7 variant for Kryo
git fetch $LINK refs/changes/93/266393/16 && git cherry-pick FETCH_HEAD #Add support for an armv8 variant for Kryo
git fetch $LINK refs/changes/13/365413/2 && git cherry-pick FETCH_HEAD # Make use of specific Kryo targeting in Clang
git fetch $LINK refs/changes/12/367312/2 && git cherry-pick FETCH_HEAD # soong: always use -mfpu=neon-vfpv4 for Krait targets
git fetch $LINK refs/changes/32/367332/3 && git cherry-pick FETCH_HEAD # soong: use optimal FPU on Cortex-A15
git fetch $LINK refs/changes/92/367392/2 && git cherry-pick FETCH_HEAD # soong: use optimal FPU for Cortex-A53 and Cortex-A53.A57
popd

pushd $ANDROOT/bootable/recovery
LINK=$HTTP && LINK+="://android.googlesource.com/platform/bootable/recovery"
git fetch $LINK refs/changes/35/517735/2 && git cherry-pick FETCH_HEAD # Split framebuffer for 4K screen.
popd

pushd $ANDROOT/external/wpa_supplicant_8
LINK=$HTTP && LINK+="://android.googlesource.com/platform/external/wpa_supplicant_8"
git fetch $LINK refs/changes/00/512300/1 && git cherry-pick FETCH_HEAD #KRACK patch set
git fetch $LINK refs/changes/01/512301/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/02/512302/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/03/512303/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/04/512304/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/05/512305/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/06/512306/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/07/512307/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
git fetch $LINK refs/changes/37/464137/1 && git cherry-pick FETCH_HEAD # gps: use TARGET_BOARD_AUTO to override qcom hals
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
git fetch $LINK refs/changes/91/294291/1 && git cherry-pick FETCH_HEAD # Add msm8976 tasha sound card detection to msm8916 HAL
git fetch $LINK refs/changes/86/333386/1 && git cherry-pick FETCH_HEAD # post_proc: Enable post processing for msm8952
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
git fetch $LINK refs/changes/39/422439/2 && git cherry-pick FETCH_HEAD # mm-video-v4l2: ifdef proprietary codecs
git fetch $LINK refs/changes/55/522855/1 && git cherry-pick FETCH_HEAD # msm8998: vdec: Add missing ifdefs for UBWC on DPB buffer decision
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
git fetch $LINK refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD # sdm: core: Update the mixer, framebuffer and display properly
git fetch $LINK refs/changes/36/437236/1 && git cherry-pick FETCH_HEAD #sdm: hwc2: Implement {get,set}ActiveConfig and fix for DRS
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
git fetch $LINK refs/changes/17/478117/1 && git cherry-pick FETCH_HEAD # bt: use TARGET_BOARD_AUTO to override qcom hals
popd

pushd $ANDROOT/system/core
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/core"
git fetch $LINK refs/changes/37/469437/1 && git cherry-pick FETCH_HEAD # healthd: charger: Add board overrides in mode_charger
git fetch $LINK refs/changes/92/497892/2 && git cherry-pick FETCH_HEAD # add odm partition to ld.config.legacy
popd

pushd $ANDROOT/frameworks/av
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/av"
git fetch $LINK refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD # stagefright: Fix buffer handle retrieval in signalBufferReturned
popd

pushd $ANDROOT/packages/inputmethods/LatinIME
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/inputmethods/LatinIME"
git fetch $LINK refs/changes/78/469478/1 && git cherry-pick FETCH_HEAD # Don't crash when displaying the " key
popd
