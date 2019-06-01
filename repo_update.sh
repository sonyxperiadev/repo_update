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


pushd $ANDROOT/hardware/qcom/data/ipacfg-mgr/sdm845
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/sdm845/data/ipacfg-mgr"
# guard use of kernel sources
# Change-Id: Ie8e892c5a7cca28cc58cbead88a9796ebc80a9f8
apply_gerrit_cl_commit refs/changes/23/834623/1 d8c88764440b0114b5f10bd9561a6b5dc4aab0e3
popd

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
# gps: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
apply_gerrit_cl_commit refs/changes/47/728147/2 147270f08ac33d737405afc555b3ddb6f1308336

LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/sdm845/gps"
# Revert "Handle updating the carrier configuration"
# Change-Id: I071ddb4fba837393b99f156a27047f74bfd0ca00
apply_gerrit_cl_commit refs/changes/24/975124/1 2b7b9bcb4744bf5c987a7aa4c59eaa5f6b5e1705
# Revert "FR 46082 - SUPL Network Setup Improvements"
# Change-Id: Iec3e5c78c907b78cf5145c3ba11e14e40bc04396
apply_gerrit_cl_commit refs/changes/23/975123/2 9671b8fb206693eab38715b050f91e2c94d11f8b
# sdm845: android/gnss: Fix format specifier in log
# Change-Id: I223a192d7755826151ebc970d72cffea90179981
apply_gerrit_cl_commit refs/changes/25/975125/1 f7f8750e60bcd0261648dfdb57eeeaefac87b777
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
# audio: add sm8150 into support platform list
# Change-Id: Ic0e99aa9bd25790920f9cc13e42c0bd2de815fe6
git revert --no-edit 07f96d11649ffe2af61f83b4c7f22d12b407e03f
# hal: enable audio_hw flag for sdm710 platform
# Change-Id: I98fc64fc972dd073cde394aa59dafbde892ba06a
git revert --no-edit e56cd4bc673e7068d59803b9ac02f660e6bfd14e
# hal: Correct mixer control name for 3.5mm headphone
# Change-Id: I749609aabfed53e8adb3575695c248bf9a674874
git revert --no-edit 39a2b8a03c0a8a44940ac732f636d9cc1959eff2
# Add msm8976 tasha sound card detection to msm8916 HAL
# Change-Id: I9ac11e781cf627fa5efe586c96e48bfd04f32485
apply_gerrit_cl_commit refs/changes/49/728149/5 60f127241193694fa369adef134bdf3dd4bb9e8d
# post_proc: Enable post processing for msm8952
# Change-Id: If1162f8696f60ce68452249e5e546aec1d7aa5e1
apply_gerrit_cl_commit refs/changes/50/728150/4 3df44637ca88e0c3b3a8af17a052d65897385996
# Define default msm8998 pcm device for voicemmode call
# Change-Id: I9c7aa65bdcc0e460e287fd8e602b3a12e5be2191
apply_gerrit_cl_commit refs/changes/51/728151/3 798fc75d957367cb1b8d2c5634d19ac95087efd9
# hal: enable audio hal on sdm660
# Change-Id: I0edd5fa2c67eb7a96a44e907060dcbb273e983ac
apply_gerrit_cl_commit refs/changes/52/728152/4 93d7228217afa6a7b07b0df21d46b333847524e9
# post_proc: Enable post processing for sdm660
# Change-Id: I18b9cec56c6197b4465e8009c7e50aa95e111d32
apply_gerrit_cl_commit refs/changes/53/728153/3 9ea9d3f27686b5bccd75625c127518070d7a93e9
# hal: msm8916: Fix for vndk compilation errors
# Change-Id: Iffd8a3c00a2a1ad063e10c0ebf3ce9e88e3edea0
apply_gerrit_cl_commit refs/changes/14/777714/1 065ec9c4857fdd092d689a0526e0caeaaa6b1d72
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
# msm8998: vdec: Add missing ifdefs for UBWC on DPB buffer decision
# Change-Id: I76131db5272b97016679c5bc0bf6ae099167cd03
apply_gerrit_cl_commit refs/changes/39/728339/1 b641243647a7cd3f382dd2be43b74f9d6b7f9310
# msm8998: mm-video-v4l2: enable compilation for both 3.18 kernel and 4.9 kernel
# Change-Id: If1eb2575dd80a1e6684c84e573baf78ae698bb20
apply_gerrit_cl_commit refs/changes/54/813054/1 01062d8acaae88b141893d69358d6c13e3495377
# msm8998: mm-video-v4l2: Renaming the AU-Delimiter params/extens
# Change-Id: I3feccfbb06e4e237a601a355ab2f2573a165ed3b
apply_gerrit_cl_commit refs/changes/55/813055/1 cb97584647999d7ea8df858f2c3f4bf04f408f34
popd

pushd $ANDROOT/hardware/qcom/media/sdm845
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/sdm845/media"
# Avoid missing dependency error for AOSP builds
# Change-Id: I19aa7a79f60bfd1182b5846ed54bf0fbf4fe0419
apply_gerrit_cl_commit refs/changes/80/832780/1 3a2fe3ec7974f9f1e9772d0009dc4df01937f237
# guard use of kernel sources
# Change-Id: I9b8cd5200cdfcc5d5ada39e6158383e7da221ae7
apply_gerrit_cl_commit refs/changes/84/832784/1 07a63defb34cd0a18849d4488ef11a8793e6cf3b
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
# bt: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
apply_gerrit_cl_commit refs/changes/69/728569/1 e0e30f0d46ef2ff5bcb707eaf47a596cb57b65af
popd

pushd $ANDROOT/hardware/nxp/nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/nxp/nfc"
# Add pn547, pn548 support
# Change-Id: Ia41714392860fbffc037ee9957a40499399d6560
apply_gerrit_cl_commit refs/changes/24/974924/1 708c4d124ae6afcfe533f5ba90b56736a292b9ff
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
# Add camera key long press handling
# Change-Id: I9e68032eee221c20608f0d2c491c2b308350f7f6
apply_gerrit_cl_commit refs/changes/15/727815/1 7913f55462b61c17b0700cf57d3f1a375bb4c565
# fwb: Add check for odm version
# Change-Id: Ifab6ca5c2f97840bb4192226f191e624267edb32
apply_gerrit_cl_commit refs/changes/75/728575/1 d6f654b013b00fa55b5c50f3f599df50847811bb
# Fix bug Device that can't support adoptable storage cannot read the sdcard.
# Change-Id: I7afe5078650fe646e79fced7456f90d4af8a449a
apply_gerrit_cl_commit refs/changes/05/728605/1 b6f563436ca1b1496bf6026453e5b805c856f9e6
# SystemUI: Implement burn-in protection for status-bar/nav-bar items
# Change-Id: I828dbd4029b4d3b1f2c86b682a03642e3f9aeeb9
apply_gerrit_cl_commit refs/changes/40/824340/1 6272c6244d2b007eb6ad08fb682d77612555d1ac
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +e
