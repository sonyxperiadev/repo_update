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

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
# gps: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
git fetch $LINK refs/changes/47/728147/2 && git cherry-pick FETCH_HEAD
# Revert "Remove etc folder under hardware/qcom/gps"
git revert --no-edit 484979c524067125b56d59afb102003ff48e3702
# Revert "Handle updating the carrier configuration"
git revert --no-edit f475797d3c031ae97a393fa3e899034836fe7ba6
# Revert "FR 46082 - SUPL Network Setup Improvements"
git revert --no-edit 35a95e0a9bc9aeab1bb1847180babda2da5fbf90
popd

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/sdm845/gps"
# gps: sdm845: gnss: use correct format specifier in log
# Change-Id: I24ad0342d6d26f1c7fe2fcac451a71bbfba8bfe0
git fetch $LINK refs/changes/39/804439/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
# hal: enable audio_hw flag for sdm710 platform
# Change-Id: I98fc64fc972dd073cde394aa59dafbde892ba06a
git revert --no-edit e56cd4bc673e7068d59803b9ac02f660e6bfd14e
# Add msm8976 tasha sound card detection to msm8916 HAL
# Change-Id: I9ac11e781cf627fa5efe586c96e48bfd04f32485
git fetch $LINK refs/changes/49/728149/5 && git cherry-pick FETCH_HEAD
# post_proc: Enable post processing for msm8952
# Change-Id: If1162f8696f60ce68452249e5e546aec1d7aa5e1
git fetch $LINK refs/changes/50/728150/4 && git cherry-pick FETCH_HEAD
# Define default msm8998 pcm device for voicemmode call
# Change-Id: I9c7aa65bdcc0e460e287fd8e602b3a12e5be2191
git fetch $LINK refs/changes/51/728151/3 && git cherry-pick FETCH_HEAD
# hal: enable audio hal on sdm660
# Change-Id: I0edd5fa2c67eb7a96a44e907060dcbb273e983ac
git fetch $LINK refs/changes/52/728152/4 && git cherry-pick FETCH_HEAD
# hal: msm8916: Fix for vndk compilation errors
# Change-Id: Iffd8a3c00a2a1ad063e10c0ebf3ce9e88e3edea0
git fetch $LINK refs/changes/53/728153/3 && git cherry-pick FETCH_HEAD
# hal: msm8916: Fix for vndk compilation errors
# Change-Id: Iffd8a3c00a2a1ad063e10c0ebf3ce9e88e3edea0
git fetch $LINK refs/changes/14/777714/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
# msm8998: vdec: Add missing ifdefs for UBWC on DPB buffer decision
# Change-Id: I76131db5272b97016679c5bc0bf6ae099167cd03
git fetch $LINK refs/changes/39/728339/1 && git cherry-pick FETCH_HEAD
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
# Change-Id: I8e1324787e35f2c675f1c8580901fb3fadc8f3c9
git fetch $LINK refs/changes/09/729209/2 && git cherry-pick FETCH_HEAD
# hwc2: Do not treat color mode errors as fatal at init
# Change-Id: I56926f320eb7719a22475793322d19244dd5d4d5
git fetch $LINK refs/changes/10/729210/1 && git cherry-pick FETCH_HEAD
# msm8998: gralloc1: disable UBWC if video encoder client has no support
# Change-Id: I1ff2489b0ce8fe36a801881b848873e591077402
git fetch $LINK refs/changes/11/729211/1 && git cherry-pick FETCH_HEAD
# color_manager: Update display color api libname
# Change-Id: I3626975ddff8458c641dc60b3632581512f91b94
git fetch $LINK refs/changes/12/729212/1 && git cherry-pick FETCH_HEAD
# msm8998: sdm: hwc2: Added property to disable skipping client color transform.
# Change-Id: I5e2508b2de391007f93064fe5bd506dd62050fbc
git fetch $LINK refs/changes/13/729213/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
# bt: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
git fetch $LINK refs/changes/69/728569/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bootctrl
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bootctrl"
# Android.mk: add sdm710
# Change-Id: I82f2321d580cb2fdb15d2343e39abed5ccda50b1
git revert --no-edit a8e07aecb24898d7d2b49cb785b0c193a4b134b4
# Replace hardcoded build barrier with a generic one
# Change-Id: I34ee90a2818ad23cc6b9233bdde126a0965fae0d
git fetch $LINK refs/changes/70/728570/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/nxp/nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/nxp/nfc"
# hardware: nxp: Restore pn548 support
# Change-Id: Iafb0d31626d0a8b9faf22f5307ac8b0a5a9ded37
git fetch $LINK refs/changes/61/744361/2 && git cherry-pick FETCH_HEAD
# hardware: nxp: Restore pn547 support
# Change-Id: I498367f676f8c8d7fc13e849509d0d8a05ec89a8
git fetch $LINK refs/changes/62/744362/5 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
# Add camera key long press handling
# Change-Id: I9e68032eee221c20608f0d2c491c2b308350f7f6
git fetch $LINK refs/changes/15/727815/1 && git cherry-pick FETCH_HEAD
# fwb: Add check for odm version
# Change-Id: Ifab6ca5c2f97840bb4192226f191e624267edb32
git fetch $LINK refs/changes/75/728575/1 && git cherry-pick FETCH_HEAD
# Fix bug Device that can't support adoptable storage cannot read the sdcard.
# Change-Id: I7afe5078650fe646e79fced7456f90d4af8a449a
git fetch $LINK refs/changes/05/728605/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/core
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/core"
# Show bootanimation after decrypt
# Change-Id: I355ccdbb2e2f27d897e2e0ee00f9300ef38ede03
git fetch $LINK refs/changes/01/741001/2 && git cherry-pick FETCH_HEAD
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +e
