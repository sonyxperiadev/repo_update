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

    local _manifest_branch _head_before_applying

    # TODO: repo info is slow, even if only fetching locally. We should
    # perhaps just take the manifest branch once for a common repo like `.repo/manifests`?
    _manifest_branch=$(repo info -l . | sed -n 's/^Manifest branch: //p')
    # Only include current commits in range. Do not search in picks/reverts that are applied
    # in this session
    _head_before_applying=$(git rev-parse HEAD)

    # Use --no-commit-id to make patch-id emit the second hash as null rather
    # than the commit id (which is exactly what we _do not_ want to match).
    # This hash is popped off anyway with the `${_hash%% *}' below.
    # See also https://git-scm.com/docs/git-patch-id:
    #   When dealing with git diff-tree output, it takes advantage of the fact
    #   that the patch is prefixed with the object name of the commit, and
    #   outputs two 40-byte hexadecimal strings. The first string is the patch
    #   ID, and the second string is the commit ID. This can be used to make a
    #   mapping from patch ID to commit ID.

    # Prepare a mapping from an existing commit to its stable patch-id:
    EXISTING_REV_AND_PATCHID_PAIRS=$(for _rev in $(git rev-list "$_manifest_branch..$_head_before_applying"); do
        local _hash
        _hash=$(git -c diff.noprefix=true show --no-commit-id "$_rev" | git patch-id --stable)
        echo "$_rev-${_hash%% *}"
    done)
}

is_stable_patchid_in_range() {
    local _stable_hash=$1
    local _rev_and_hash_pairs=$2

    [ -z "$_stable_hash" ] && (echo "ERROR: No patchid passed"; exit 1)
    [ -z "$_rev_and_hash_pairs" ] && (echo "ERROR: No range passed"; exit 1)

    for i in $_rev_and_hash_pairs; do
        local _rev=${i%%-*}
        local _hash=${i##*-}
        if [ "$_stable_hash" == "$_hash" ]; then
            echo -n "$_rev"
            return
        fi
    done

    false
}

is_patch_already_applied() {
    local _commit=$1
    local _stable_hash

    [ -z "$_commit" ] && (echo "ERROR: No commit passed"; exit 1)

    _stable_hash=$(git -c diff.noprefix=true show --no-commit-id "$_commit" | git patch-id --stable)
    is_stable_patchid_in_range "${_stable_hash%% *}" "$EXISTING_REV_AND_PATCHID_PAIRS"
}

is_patch_already_reverted() {
    local _commit=$1
    local _stable_hash

    [ -z "$_commit" ] && (echo "ERROR: No commit passed"; exit 1)

    _stable_hash=$(git -c diff.noprefix=true show --no-commit-id -R "$_commit" | git patch-id --stable)
    _stable_hash=${_stable_hash%% *}
    is_stable_patchid_in_range "$_stable_hash" "$EXISTING_REV_AND_PATCHID_PAIRS"
}

apply_gerrit_cl_commit() {
    local _ref=$1
    local _commit=$2
    local _fetched

    [ -z "$_ref" ] && (echo "ERROR: No gerrit fetch ref passed"; exit 1)
    [ -z "$_commit" ] && (echo "ERROR: No commit passed"; exit 1)

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
        _commit="$_fetched"
    fi

    if _applied_as=$(is_patch_already_applied "$_commit"); then
        echo "$_commit appears to be applied as $_applied_as already"
    else
        git cherry-pick "$_commit"
    fi
}

revert_commit() {
    _commit=$1

    [ -z "$_commit" ] && (echo "ERROR: No commit passed"; exit 1)

    if _reverted_as=$(is_patch_already_reverted "$_commit"); then
        echo "$_commit appears to be reverted as $_reverted_as already"
    else
        git revert --no-edit "$_commit"
    fi
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
revert_commit 39a2b8a03c0a8a44940ac732f636d9cc1959eff2

# Switch msmnile to new Audio HAL
# Change-Id: I28e8c28822b29af68b52eb84f07f1eca746afa6d
revert_commit d0d5c9135fed70a25a42f09f0e32b056bc7b15a8

# switch sm8150 to msmnile
# Change-id: I37b9461240551037812b35d96d0b2db5e30bae5f
revert_commit 8e9b92d2c87e9d1cd96ef153853287cb79d5934c

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
apply_gerrit_cl_commit refs/changes/40/824340/3 fcc013282943c935af8225a914a525e996d42866
popd

enter_aosp_dir build/make build
# releasetools: Use du -b
# Change-Id: I1955261de0f6323518b214e2731ef4879c3304e0
apply_gerrit_cl_commit refs/changes/03/1269603/1 96a913e7f4eceb705b4e6862068117670ce31b79
popd

enter_aosp_dir system/vold
# Switch to exfatprogs compatible fsck parameter
# Change-Id: I2c436816a293a36fc9f0cd635cdb9ca3b5f88bfc
apply_gerrit_cl_commit refs/changes/37/1441937/1 2035a83916914ec8c6ecaacb6f23ea5256be2edd
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
