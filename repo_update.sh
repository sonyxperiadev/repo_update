#!/bin/bash

# exit script immediately if a command fails or a variable is unset
set -eu

# Some people require insecure proxies
HTTP=https
if [ "${INSECURE_PROXY:-}" = "TRUE" ]; then
    HTTP=http
fi

ANDROOT=$PWD

pushd() {
    command pushd "$@" > /dev/null
}

popd() {
    command popd > /dev/null
}

enter_aosp_dir() {
    [ -z "$1" ] && (echo "ERROR: enter_aosp_dir must be called with at least a path! (and optionally an alternative fetch path)"; exit 1)

    [ "$ANDROOT" != "$PWD" ] && echo "WARNING: enter_aosp_dir was not called from $ANDROOT. Please fix the script to call popd after every block of patches!"

    LINK="$HTTP://android.googlesource.com/platform/${2:-$1}"
    echo "Entering $1"
    pushd "$ANDROOT/$1"
}

apply_gerrit_cl_commit() {
    local _ref=$1
    local _commit=$2
    local _fetched

    # Check whether the commit is already stored
    if [ -z "$(git rev-parse --quiet --verify "$_commit^{commit}")" ]
    # If not, fetch the ref from $LINK
    then
        git fetch "$LINK" "$_ref"
        _fetched=$(git rev-parse FETCH_HEAD)
        if [ "$_fetched" != "$_commit" ]
        then
            echo "$(pwd): WARNING:"
            echo -e "\tFetched commit is not \"$_commit\""
            echo -e "\tPlease update the commit hash for $_ref to \"$_fetched\""
        fi
        _commit=$_fetched
    fi
    git cherry-pick "$_commit"
}

if [ "${SKIP_SYNC:-}" != "TRUE" ]; then
    pushd "$ANDROOT/.repo/local_manifests"
    git pull
    popd

    repo sync -j8 --current-branch --no-tags
fi

enter_aosp_dir vendor/qcom/opensource/data/ipacfg-mgr/sdm845 hardware/qcom/sdm845/data/ipacfg-mgr
# guard use of kernel sources
# Change-Id: Ie8e892c5a7cca28cc58cbead88a9796ebc80a9f8
apply_gerrit_cl_commit refs/changes/23/834623/2 0f42902cbc526d6d5badcece2add39d5badd1537
popd

enter_aosp_dir hardware/qcom/audio
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

enter_aosp_dir hardware/nxp/nfc
# hardware: nxp: Restore pn548 support to 1.1 HAL
# Change-Id: Ifbef5a5ec0928b0a90b2fc71d84872525d0cf1a6
apply_gerrit_cl_commit refs/changes/77/980177/3 0285b720ea752c8dcf28c35d794990e982103ada
# hardware: nxp: Restore pn547 support
# Change-Id: I226fa084d22850a8610f1d67ef30b96250fbd570
# (Cherry-picked from: I498367f676f8c8d7fc13e849509d0d8a05ec89a8)
apply_gerrit_cl_commit refs/changes/69/980169/2 a58def9e0ce610f1a349d5de31f267129a0a2397
popd

enter_aosp_dir hardware/interfaces
# [android10-dev] thermal: Init module to NULL
# Change-Id: I250006ba6fe9d91e765dde1e4534d5d87aaab879
apply_gerrit_cl_commit refs/changes/90/1320090/1 3861f7958bec14685cde5b8fee4e590cece76d68
popd

enter_aosp_dir frameworks/base
# Fix bug Device that can't support adoptable storage cannot read the sdcard.
# Change-Id: I7afe5078650fe646e79fced7456f90d4af8a449a
apply_gerrit_cl_commit refs/changes/48/1295748/1 6ec651f12a9b67a9d2e41c2fe4d9a71c29d1cf34
# SystemUI: Implement burn-in protection for status-bar/nav-bar items
# Change-Id: I828dbd4029b4d3b1f2c86b682a03642e3f9aeeb9
apply_gerrit_cl_commit refs/changes/40/824340/2 cf575e7f64a976918938e6ea3bc747011fb3b551
popd

enter_aosp_dir system/extras
# verity: Do not increment data when it is nullptr.
apply_gerrit_cl_commit refs/changes/52/1117052/1 c82514bd034f214b16d273b10c676dd63a9e603b
popd

enter_aosp_dir system/sepolicy
# property_contexts: Remove compatible guard
apply_gerrit_cl_commit refs/changes/00/1185400/1 668b7bf07a69e51a6c190d6b366d574b9e4af1d4
popd

enter_aosp_dir packages/apps/DeskClock
# DeskClock - Moved the android:targetSdkVersion to 25 to fix "Clock has stopped"
# message displayed when Alarm trigger.
# Change-Id: I75a96e1ed4acebd118c212b51b7d0e57482a66bb
apply_gerrit_cl_commit refs/changes/26/987326/1 e6351b3b85b2f5d53d43e4797d3346ce22a5fa6f
popd

enter_aosp_dir packages/apps/Messaging
# AOSP/Messaging - Update the Messaging version to 24 until notification
# related logic changes are made.
# Change-Id: Ic263e2c63d675c40a2cfa1ca0a8776c8e2b510b9
apply_gerrit_cl_commit refs/changes/82/941082/1 8e71d1b707123e1b48b5529b1661d53762922400
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
