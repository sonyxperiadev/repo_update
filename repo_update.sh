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
        git fetch $LINK $_ref
        _fetched=$(git rev-parse FETCH_HEAD)
        if [ "$_fetched" != "$_commit" ]
        then
            echo "$(pwd): WARNING:"
            echo -e "\tFetched commit is not \"$_commit\""
            echo -e "\tPlease update the commit hash for $_ref to \"$_fetched\""
        fi
        git cherry-pick FETCH_HEAD
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

pushd $ANDROOT/build/make
LINK="$HTTP://android.googlesource.com/platform/build"
# build: fs_config: Fix cases without vendor/oem partition
# Change-Id: I236e30445b303b4945467b5dc4387d54b5d984f9
apply_gerrit_cl_commit refs/changes/28/970728/8 8453f02c652e1ec0467648064393b61c9b424d68
popd

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
# Revert "Remove etc folder under hardware/qcom/gps"
git revert --no-edit 484979c524067125b56d59afb102003ff48e3702
# Revert "Handle updating the carrier configuration"
git revert --no-edit f475797d3c031ae97a393fa3e899034836fe7ba6
# Revert "FR 46082 - SUPL Network Setup Improvements"
git revert --no-edit 35a95e0a9bc9aeab1bb1847180babda2da5fbf90

LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/sdm845/gps"
# gps: sdm845: gnss: use correct format specifier in log
# Change-Id: I24ad0342d6d26f1c7fe2fcac451a71bbfba8bfe0
apply_gerrit_cl_commit refs/changes/39/804439/1 c1bdb439aaf7ecddd9f499dce5c7b56ea458cce4
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
# hal: Correct mixer control name for 3.5mm headphone
# Change-Id: I749609aabfed53e8adb3575695c248bf9a674874
git revert --no-edit 39a2b8a03c0a8a44940ac732f636d9cc1959eff2

# Switch msmnile to new Audio HAL
# Change-Id: I28e8c28822b29af68b52eb84f07f1eca746afa6d
git revert --no-edit d0d5c9135fed70a25a42f09f0e32b056bc7b15a8

# switch sm8150 to msmnile
# Change-id: I37b9461240551037812b35d96d0b2db5e30bae5f
git revert --no-edit 8e9b92d2c87e9d1cd96ef153853287cb79d5934c

#Add msm8976 tasha sound card detection to msm8916 HAL
#Change-Id:  Idc5ab339bb9c898205986ba0b4c7cc91febf19de
apply_gerrit_cl_commit refs/changes/99/1112099/2 5d6e73eca6f83ce5e7375aa1bd6ed61143d30978

#hal: enable audio hal on sdm660
#Change-Id: I7bb807788e457f7ec6ce5124dfb1d88dc96d8127
apply_gerrit_cl_commit refs/changes/00/1112100/2 eeecf8a399080598e5290d3356b0ad557bd0ccbd

# hal: msm8916: Fix for vndk compilation errors
# Change-Id: Iffd8a3c00a2a1ad063e10c0ebf3ce9e88e3edea0
apply_gerrit_cl_commit refs/changes/14/777714/1 065ec9c4857fdd092d689a0526e0caeaaa6b1d72

# hal: msm8916: Add missing bracket to close function definition.
# Change-Id: I8296a8fb551097fabf72115d2cec0849671b91ea
apply_gerrit_cl_commit refs/changes/51/1118151/1 b7c1366360089d6cd1b4b18c70085a802a6a0544
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

pushd $ANDROOT/hardware/qcom/bootctrl
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bootctrl"
# Build bootctrl.sdm710 with Android.bp.
# Change-Id: Ib29d901b44ad0ec079c3e979bfdcd467e1a18377
apply_gerrit_cl_commit refs/changes/01/965401/1 c665a9c43f379f754b4ee25df2818b6c20c5346e
# Revert^2 "Build bootctrl.msm8998 with Android.bp.""
# Change-Id: I6a85b7885903df818deb32c40c751ac4358a6dbc
apply_gerrit_cl_commit refs/changes/93/968693/1 1933d30528c58598d7423d8b307d8e0fd2c50ad5
# Build bootctrl.msm8996 with Android.bp.
# Android.mk itself will be removed in a separate CL.
# Change-Id: I864bd626d25723bd390b2453022d9cd47a54d2a2
apply_gerrit_cl_commit refs/changes/96/967996/3 b229dfc102d5ea8e659514c61f6520ab3f9f777c
# Remove Android.mk rules for building bootctrl.
# Change-Id: Ib110508065f47a742acd92e03ea42901e8002e4f
apply_gerrit_cl_commit refs/changes/87/971787/1 7bde6868ff24001f8b6deb8cf643d86d71978b93
popd

pushd $ANDROOT/hardware/nxp/nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/nxp/nfc"
# hardware: nxp: Restore pn548 support to 1.1 HAL
# Change-Id: Ifbef5a5ec0928b0a90b2fc71d84872525d0cf1a6
apply_gerrit_cl_commit refs/changes/77/980177/3 0285b720ea752c8dcf28c35d794990e982103ada
# hardware: nxp: Restore pn547 support
# Change-Id: I226fa084d22850a8610f1d67ef30b96250fbd570
# (Cherry-picked from: I498367f676f8c8d7fc13e849509d0d8a05ec89a8)
apply_gerrit_cl_commit refs/changes/69/980169/2 a58def9e0ce610f1a349d5de31f267129a0a2397
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
# fwb: Add check for odm version
# Change-Id: Ifab6ca5c2f97840bb4192226f191e624267edb32
apply_gerrit_cl_commit refs/changes/75/728575/1 d6f654b013b00fa55b5c50f3f599df50847811bb
# Fix bug Device that can't support adoptable storage cannot read the sdcard.
# Change-Id: I7afe5078650fe646e79fced7456f90d4af8a449a
apply_gerrit_cl_commit refs/changes/05/728605/1 b6f563436ca1b1496bf6026453e5b805c856f9e6
# SystemUI: Implement burn-in protection for status-bar/nav-bar items
# Change-Id: I828dbd4029b4d3b1f2c86b682a03642e3f9aeeb9
apply_gerrit_cl_commit refs/changes/40/824340/2 cf575e7f64a976918938e6ea3bc747011fb3b551
# core/Build: ro.system when comparing fingerprint
# Change-Id: Ie5e972047d7983b411004a3f0d67c4636a205162
apply_gerrit_cl_commit refs/changes/96/1147496/2 88c1bf0737f1209c62a7e70a49263834d2104d47
popd

pushd $ANDROOT/system/extras
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/extras"
# verity: Do not increment data when it is nullptr.
apply_gerrit_cl_commit refs/changes/52/1117052/1 c82514bd034f214b16d273b10c676dd63a9e603b
popd

pushd $ANDROOT/system/sepolicy
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/sepolicy"
# property_contexts: Remove compatible guard
apply_gerrit_cl_commit refs/changes/00/1185400/1 668b7bf07a69e51a6c190d6b366d574b9e4af1d4
popd

pushd $ANDROOT/packages/apps/DeskClock
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/apps/DeskClock"
# DeskClock - Moved the android:targetSdkVersion to 25 to fix "Clock has stopped"
# message displayed when Alarm trigger.
# Change-Id: I75a96e1ed4acebd118c212b51b7d0e57482a66bb
apply_gerrit_cl_commit refs/changes/26/987326/1 e6351b3b85b2f5d53d43e4797d3346ce22a5fa6f
popd

pushd $ANDROOT/packages/apps/Messaging
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/apps/Messaging"
# AOSP/Messaging - Update the Messaging version to 24 until notification
# related logic changes are made.
# Change-Id: Ic263e2c63d675c40a2cfa1ca0a8776c8e2b510b9
apply_gerrit_cl_commit refs/changes/82/941082/1 8e71d1b707123e1b48b5529b1661d53762922400
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +e
