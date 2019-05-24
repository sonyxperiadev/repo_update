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

apply_gerrit_cl_commit() {
    _ref=$1
    _commit=$2
    # Check whether the commit is already stored
    if [ -z $(git rev-parse --quiet --verify $_commit^{commit}) ]
    # If not, fetch the ref from $LINK
    then
        git fetch $LINK $_ref && git cherry-pick FETCH_HEAD
    else
        git cherry-pick $_commit
    fi
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
apply_gerrit_cl_commit refs/changes/59/555059/1 c7ec6d46fb619a25628427200c91eced02bc8edd
# linker: add support for odm partition
# Change-Id: Ia7786e047cc565d74d25c025dacf9266b3763650
apply_gerrit_cl_commit refs/changes/22/553222/1 074a9fd3da4d1d7a317ce08fa65835788d98da7b
popd

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
# gps: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
apply_gerrit_cl_commit refs/changes/37/464137/1 ee0e0a15396298c18df3e582a7bdf59c20a766f0
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
# Add msm8976 tasha sound card detection to msm8916 HAL
# Change-Id: I9ac11e781cf627fa5efe586c96e48bfd04f32485
apply_gerrit_cl_commit refs/changes/08/708808/1 8a899e35616cb63842f0f35fb9b8a1c1c00d1751
# post_proc: Enable post processing for msm8952
# Change-Id: If1162f8696f60ce68452249e5e546aec1d7aa5e1
apply_gerrit_cl_commit refs/changes/09/708809/1 38685fde4fb6817f24f74cf134471365f25dfb99
# Define default msm8998 pcm device for voicemmode call
# Change-Id: I073d21a33270bc5fc659d7cfa37b2ee8c7f46d57
apply_gerrit_cl_commit refs/changes/56/535256/1 d36071489623bf0cccac75bbbd9d05898c169b5e
# hal: msm8916: load config files from multiple locations
# Change-Id: I33bdd1e1d5117dfc26784fc883f861ecab74306b
apply_gerrit_cl_commit refs/changes/43/576643/1 ac0c864115ec375edacd80ebd3ff76aca93ef07b
# hal: enable audio hal on sdm660
# Change-Id: I0edd5fa2c67eb7a96a44e907060dcbb273e983ac
apply_gerrit_cl_commit refs/changes/41/602841/4 0c717b9ee5857da2f81a6be59ca25063d79658f2
# post_proc: Enable post processing for sdm660
# Change-Id: I18b9cec56c6197b4465e8009c7e50aa95e111d32
apply_gerrit_cl_commit refs/changes/42/602842/2 19807916ba8576eadf91cf783b2474115ba733ac
# audio: add support for sdm845 platform
# Change-Id: Ib4bf9fd717d71990639b19550ddd0e8c74649314
apply_gerrit_cl_commit refs/changes/10/708810/1 1cc698d74e7e78bc3f312ec49021ceba154cff64
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
# msm8998: vdec: Add missing ifdefs for UBWC on DPB buffer decision
# Change-Id: I76131db5272b97016679c5bc0bf6ae099167cd03
apply_gerrit_cl_commit refs/changes/55/522855/1 705c794a5f1bf4100e0a5d05c4e39f90fe856b7d
# media: add barier for kernel headers
# Change-Id: I1d5c77acbf8589aa01bfb4b6a0d0e466374d884c
apply_gerrit_cl_commit refs/changes/15/708815/1 58ca30a80601bcd8cf769dff5293cf2535f89ddf
# media: disabled functions that need blobs
# Change-Id: I3a6ec444f732c5faf71a9d29a3116fc70bf07782
apply_gerrit_cl_commit refs/changes/16/708816/1 e88e2ac317185b47a033e6b1b09782005756321a
# msm8952: fix registry_table name
# Change-Id: I2789555066ff3787ca1b797f4eff75c284930896
apply_gerrit_cl_commit refs/changes/17/708817/1 006685ede914c8a261695fbde03ce288dcd02746
# msm8996: copy the registry tables from msm8998 folder
# Change-Id: Ic9a3246193f1644f6236769f02b166804c86057f
apply_gerrit_cl_commit refs/changes/42/713242/2 50caede1eff519af47d65db948cb82adc4c2fac4
# msm8996: fix build when prop blobs are not prezent
# Change-Id: I86baddb52292e65ee4a5d8dae6253920b9c0629b
apply_gerrit_cl_commit refs/changes/43/713243/2 271be0346431fc58865cdbe3a0f393d9a9589e9a
# msm8998: mm-video-v4l2: enable compilation for both 3.18 kernel and 4.9 kernel
# Change-Id: If1eb2575dd80a1e6684c84e573baf78ae698bb20
apply_gerrit_cl_commit refs/changes/54/813054/1 01062d8acaae88b141893d69358d6c13e3495377
# msm8998: mm-video-v4l2: Renaming the AU-Delimiter params/extens
# Change-Id: I3feccfbb06e4e237a601a355ab2f2573a165ed3b
apply_gerrit_cl_commit refs/changes/55/813055/1 cb97584647999d7ea8df858f2c3f4bf04f408f34
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
# sdm: core: Update the mixer, framebuffer and display properly
# Change-Id: Ib5452ebabaaf772a2582dc06d273dd23a788a348
apply_gerrit_cl_commit refs/changes/35/437235/1 a44854592776456c343bdc188c8ea04c34a8d441
# hwc2: Do not treat color mode errors as fatal at init
# Change-Id: I56926f320eb7719a22475793322d19244dd5d4d5
apply_gerrit_cl_commit refs/changes/42/576642/1 fa81468cedbf068b773de34821a30cb23f93cbc8
# msm8998: gralloc1: disable UBWC if video encoder client has no support
# Change-Id: I1ff2489b0ce8fe36a801881b848873e591077402
apply_gerrit_cl_commit refs/changes/38/602838/1 35637fc7d29c80a36b50d6dcb5594c8261bdb087
# color_manager: Update display color api libname
# Change-Id: I3626975ddff8458c641dc60b3632581512f91b94
apply_gerrit_cl_commit refs/changes/79/645379/1 293b2e8824eb4efbcf1ca8ff910d04cdf3c8f233
# display: add barier for kernel headers
# Change-Id: Ia1b4b4554bc63e1274db41ab44cfa91e7c138834
apply_gerrit_cl_commit refs/changes/12/708812/1 5bcdb87c797fcb4780a43da7e453eec85dab7a81
# display: remove blob dependency
# Change-Id: Id0b2887dec0ebc6832ee48767444c01a85ca34f8
apply_gerrit_cl_commit refs/changes/13/708813/1 6aae821ae16b3166d6fdec4a4818d14aa0c0c5da
# display: fix undeclared variable
# Change-Id: Ic6e268acb5bbfbdb3ab66a597b1e28684ee63a0c
apply_gerrit_cl_commit refs/changes/14/708814/1 0263f6f6712ef2682a8b8f4c8623df9f0612f5b5
# msm8998: sdm: hwc2: Added property to disable skipping client color transform.
# Change-Id: I5e2508b2de391007f93064fe5bd506dd62050fbc
apply_gerrit_cl_commit refs/changes/09/716909/1 df2a3a2f0910b0c4a472de0bbf002807804b89f0
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
# bt: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
apply_gerrit_cl_commit refs/changes/84/573184/1 2507b7a753fc9e308d75c258641d51164e00550d
popd

pushd $ANDROOT/hardware/qcom/bootctrl
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bootctrl"
# Replace hardcoded build barier with a generic one
# Change-Id: I34ee90a2818ad23cc6b9233bdde126a0965fae0d
apply_gerrit_cl_commit refs/changes/11/708811/1 d41045a1d11856a6b38284786e66b1a651f585f2
popd

pushd $ANDROOT/system/core
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/core"
# add odm partition to ld.config.legacy
# Change-Id: Ifdfc22a3406ae3ad1fde53618d4120fd0498f615
apply_gerrit_cl_commit refs/changes/21/553221/1 fa7958e1fb389383e62bfffbcc403da5c5a2550e
# Allow firmware loading from ODM partition
# Change-Id: I7d327bc79a04d1a2dee0fd47407eb53f9d391665
apply_gerrit_cl_commit refs/changes/41/501741/2 b398ac859c307e33dd5d439da3572b45c3e6dfc1
# Revert: healthd: restructure healthd_mode_charger
# Change-Id: I6c089460f55b8c2f75f4aa3153a5736f6f434b51
git revert --no-edit 1d540dd0f44c1c7d40878f6a7bb447e85e6207ad
# healthd: charger: Add board overrides in mode_charger
# Change-Id: Ic2b7ab6deeb52c4effe3b4af9b590950d5ee97f1
apply_gerrit_cl_commit refs/changes/37/469437/1 3ad34b520b5225e0ad6feaf2cb2e12eefa363e4d
# Show bootanimation after decrypt
# Change-Id: I355ccdbb2e2f27d897e2e0ee00f9300ef38ede03
apply_gerrit_cl_commit refs/changes/01/741001/2 f32c20174349c058b20d3819802ed8aa8277c72d
popd

pushd $ANDROOT/frameworks/av
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/av"
# stagefright: Fix buffer handle retrieval in signalBufferReturned
# Change-Id: I352293e525f75dde500ac8e71ee49209710030c3
apply_gerrit_cl_commit refs/changes/92/384692/2 1c4464cbee5a92803015efb9a8050057084b3e66
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
# Add camera key long press handling
# Change-Id: I9e68032eee221c20608f0d2c491c2b308350f7f6
apply_gerrit_cl_commit refs/changes/19/642919/5 4016b9725b32a0e83e29f8ab91b1e9234592a246
# fwb: Add check for odm version
# Change-Id: Ifab6ca5c2f97840bb4192226f191e624267edb32
apply_gerrit_cl_commit refs/changes/62/684362/1 d8f97a2bd3d15c46f2021cc6535049b7d07eada8
# Fix bug Device that can't support adoptable storage cannot read the sdcard.
# Change-Id: I7afe5078650fe646e79fced7456f90d4af8a449a
apply_gerrit_cl_commit refs/changes/70/671870/1 f31d26b22a7fcb1336d40269e878ef00626f2540
popd

pushd $ANDROOT/packages/apps/Nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/apps/Nfc"
# Make Transceive Length configurable for ISO DEP Technology
# Change-Id: I198c06fdcbcd3b45932f544fa063e920f84f7968
apply_gerrit_cl_commit refs/changes/62/666362/1 d2097407748f9323e3d0c6d1c62e737cf15f28cf
popd

pushd $ANDROOT/packages/inputmethods/LatinIME
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/inputmethods/LatinIME"
# Don't crash when displaying the " key
# Change-Id: I7b52fc62c874075d572a631c75e87caad1d365c0
apply_gerrit_cl_commit refs/changes/78/469478/1 13460fde36a1ff5bfd2314199faac11a1860dc8f
popd

pushd $ANDROOT/system/nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/nfc"
# Add NAME_ISO_DEP_MAX_TRANSCEIVE_LENGTH
# Change-Id: I75ac2f533016ab1bd1bc05879aa821c9a8729a37
apply_gerrit_cl_commit refs/changes/17/515517/10 e2f79f058b98e0a58180138969bf7e5e1e54c49c
# Increase APDU buffer size to support extended APDU
# Change-Id: I20ecf3835ff73671c89990354777e7c1073413a7
apply_gerrit_cl_commit refs/changes/15/533315/4 f1f1aaa9490ce0ac33c9b8d8e0422dfd80448af5
popd

pushd $ANDROOT/system/vold
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/vold"
# vold: add support for exFAT file system
# Change-Id: I0a83761cefd97791e3ec84a18e199dfd27a5ed0b
apply_gerrit_cl_commit refs/changes/24/703124/1 b2569ea526c5684c53f222e7dc7bc790596a7602
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +e
