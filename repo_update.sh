#!/bin/bash

# exit script immediately if a command fails
set -e

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

if [ "$SKIP_SYNC" != "TRUE" ]; then
    pushd $ANDROOT/.repo/local_manifests
    git pull
    popd

    repo sync -j8 --current-branch --no-tags
fi

pushd $ANDROOT/bionic
LINK=$HTTP && LINK+="://android.googlesource.com/platform/bionic"
# libc: add /odm/bin to the DEFPATH
# Change-Id: I28cc37a9f049d0776fbcb7f92b05652385348b3e
git fetch $LINK refs/changes/59/555059/1 && git cherry-pick FETCH_HEAD
# linker: add support for odm partition
# Change-Id: Ia7786e047cc565d74d25c025dacf9266b3763650
git fetch $LINK refs/changes/22/553222/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
# gps: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
git fetch $LINK refs/changes/37/464137/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
# Add msm8976 tasha sound card detection to msm8916 HAL
# Change-Id: I9ac11e781cf627fa5efe586c96e48bfd04f32485
git fetch $LINK refs/changes/08/708808/1 && git cherry-pick FETCH_HEAD
# post_proc: Enable post processing for msm8952
# Change-Id: If1162f8696f60ce68452249e5e546aec1d7aa5e1
git fetch $LINK refs/changes/09/708809/1 && git cherry-pick FETCH_HEAD
# Define default msm8998 pcm device for voicemmode call
# Change-Id: I073d21a33270bc5fc659d7cfa37b2ee8c7f46d57
git fetch $LINK refs/changes/56/535256/1 && git cherry-pick FETCH_HEAD
# hal: msm8916: load config files from multiple locations
# Change-Id: I33bdd1e1d5117dfc26784fc883f861ecab74306b
git fetch $LINK refs/changes/43/576643/1 && git cherry-pick FETCH_HEAD
# hal: enable audio hal on sdm660
# Change-Id: I0edd5fa2c67eb7a96a44e907060dcbb273e983ac
git fetch $LINK refs/changes/41/602841/4 && git cherry-pick FETCH_HEAD
# post_proc: Enable post processing for sdm660
# Change-Id: I18b9cec56c6197b4465e8009c7e50aa95e111d32
git fetch $LINK refs/changes/42/602842/2 && git cherry-pick FETCH_HEAD
# audio: add support for sdm845 platform
# Change-Id: Ib4bf9fd717d71990639b19550ddd0e8c74649314
git fetch $LINK refs/changes/10/708810/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
# msm8998: vdec: Add missing ifdefs for UBWC on DPB buffer decision
# Change-Id: I76131db5272b97016679c5bc0bf6ae099167cd03
git fetch $LINK refs/changes/55/522855/1 && git cherry-pick FETCH_HEAD
# media: add barier for kernel headers
# Change-Id: I1d5c77acbf8589aa01bfb4b6a0d0e466374d884c
git fetch $LINK refs/changes/15/708815/1 && git cherry-pick FETCH_HEAD
# media: disabled functions that need blobs
# Change-Id: I3a6ec444f732c5faf71a9d29a3116fc70bf07782
git fetch $LINK refs/changes/16/708816/1 && git cherry-pick FETCH_HEAD
# msm8952: fix registry_table name
# Change-Id: I2789555066ff3787ca1b797f4eff75c284930896
git fetch $LINK refs/changes/17/708817/1 && git cherry-pick FETCH_HEAD
# msm8996: copy the registry tables from msm8998 folder
# Change-Id: Ic9a3246193f1644f6236769f02b166804c86057f
git fetch $LINK refs/changes/42/713242/2 && git cherry-pick FETCH_HEAD
# msm8996: fix build when prop blobs are not prezent
# Change-Id: I86baddb52292e65ee4a5d8dae6253920b9c0629b
git fetch $LINK refs/changes/43/713243/2 && git cherry-pick FETCH_HEAD
# msm8998: mm-video-v4l2: enable compilation for both 3.18 kernel and 4.9 kernel
# Change-Id: If1eb2575dd80a1e6684c84e573baf78ae698bb20
git fetch $LINK refs/changes/54/813054/1 && git cherry-pick FETCH_HEAD
# msm8998: mm-video-v4l2: Renaming the AU-Delimiter params/extens
# Change-Id: I3feccfbb06e4e237a601a355ab2f2573a165ed3b
git fetch $LINK refs/changes/55/813055/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
# sdm: core: Update the mixer, framebuffer and display properly
# Change-Id: Ib5452ebabaaf772a2582dc06d273dd23a788a348
git fetch $LINK refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD
# hwc2: Do not treat color mode errors as fatal at init
# Change-Id: I56926f320eb7719a22475793322d19244dd5d4d5
git fetch $LINK refs/changes/42/576642/1 && git cherry-pick FETCH_HEAD
# msm8998: gralloc1: disable UBWC if video encoder client has no support
# Change-Id: I1ff2489b0ce8fe36a801881b848873e591077402
git fetch $LINK refs/changes/38/602838/1 && git cherry-pick FETCH_HEAD
# color_manager: Update display color api libname
# Change-Id: I3626975ddff8458c641dc60b3632581512f91b94
git fetch $LINK refs/changes/79/645379/1 && git cherry-pick FETCH_HEAD
# display: add barier for kernel headers
# Change-Id: Ia1b4b4554bc63e1274db41ab44cfa91e7c138834
git fetch $LINK refs/changes/12/708812/1 && git cherry-pick FETCH_HEAD
# display: remove blob dependency
# Change-Id: Id0b2887dec0ebc6832ee48767444c01a85ca34f8
git fetch $LINK refs/changes/13/708813/1 && git cherry-pick FETCH_HEAD
# display: fix undeclared variable
# Change-Id: Ic6e268acb5bbfbdb3ab66a597b1e28684ee63a0c
git fetch $LINK refs/changes/14/708814/1 && git cherry-pick FETCH_HEAD
# msm8998: sdm: hwc2: Added property to disable skipping client color transform.
# Change-Id: I5e2508b2de391007f93064fe5bd506dd62050fbc
git fetch $LINK refs/changes/09/716909/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
# bt: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
git fetch $LINK refs/changes/84/573184/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bootctrl
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bootctrl"
# Replace hardcoded build barier with a generic one
# Change-Id: I34ee90a2818ad23cc6b9233bdde126a0965fae0d
git fetch $LINK refs/changes/11/708811/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/core
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/core"
# add odm partition to ld.config.legacy
# Change-Id: Ifdfc22a3406ae3ad1fde53618d4120fd0498f615
git fetch $LINK refs/changes/21/553221/1 && git cherry-pick FETCH_HEAD
# Allow firmware loading from ODM partition
# Change-Id: I7d327bc79a04d1a2dee0fd47407eb53f9d391665
git fetch $LINK refs/changes/41/501741/2 && git cherry-pick FETCH_HEAD
# Revert: healthd: restructure healthd_mode_charger
# Change-Id: I6c089460f55b8c2f75f4aa3153a5736f6f434b51
git revert --no-edit 1d540dd0f44c1c7d40878f6a7bb447e85e6207ad
# healthd: charger: Add board overrides in mode_charger
# Change-Id: Ic2b7ab6deeb52c4effe3b4af9b590950d5ee97f1
git fetch $LINK refs/changes/37/469437/1 && git cherry-pick FETCH_HEAD
# Show bootanimation after decrypt
# Change-Id: I355ccdbb2e2f27d897e2e0ee00f9300ef38ede03
git fetch $LINK refs/changes/01/741001/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/frameworks/av
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/av"
# stagefright: Fix buffer handle retrieval in signalBufferReturned
# Change-Id: I352293e525f75dde500ac8e71ee49209710030c3
git fetch $LINK refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
# Fix bug Device that can't support adoptable storage cannot read the sdcard.
# Change-Id: I7afe5078650fe646e79fced7456f90d4af8a449a
git fetch $LINK refs/changes/19/642919/5 && git cherry-pick FETCH_HEAD
# fwb: Add check for odm version
# Change-Id: Ifab6ca5c2f97840bb4192226f191e624267edb32
git fetch $LINK refs/changes/62/684362/1 && git cherry-pick FETCH_HEAD
# Fix bug Device that can't support adoptable storage cannot read the sdcard.
# Change-Id: I7afe5078650fe646e79fced7456f90d4af8a449a
git fetch $LINK refs/changes/70/671870/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/packages/apps/Nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/apps/Nfc"
# Make Transceive Length configurable for ISO DEP Technology
# Change-Id: I198c06fdcbcd3b45932f544fa063e920f84f7968
git fetch $LINK refs/changes/62/666362/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/packages/inputmethods/LatinIME
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/inputmethods/LatinIME"
# Don't crash when displaying the " key
# Change-Id: I7b52fc62c874075d572a631c75e87caad1d365c0
git fetch $LINK refs/changes/78/469478/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/nfc"
# Add NAME_ISO_DEP_MAX_TRANSCEIVE_LENGTH
# Change-Id: I75ac2f533016ab1bd1bc05879aa821c9a8729a37
git fetch $LINK refs/changes/17/515517/10 && git cherry-pick FETCH_HEAD
# Increase APDU buffer size to support extended APDU
# Change-Id: I20ecf3835ff73671c89990354777e7c1073413a7
git fetch $LINK refs/changes/15/533315/4 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/vold
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/vold"
# vold: add support for exFAT file system
# Change-Id: I0a83761cefd97791e3ec84a18e199dfd27a5ed0b
git fetch $LINK refs/changes/24/703124/1 && git cherry-pick FETCH_HEAD
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +e
