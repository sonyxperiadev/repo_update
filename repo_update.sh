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

enter_aosp_dir bionic
# Add inaddr.h header file
# Change-Id: Iad92c39fb729538cf51bf9d9037b15515104b453
apply_gerrit_cl_commit refs/changes/84/1582884/1 5efdad358c77795bef6c011d87625b0a46b0bd0d
popd

enter_aosp_dir vendor/qcom/opensource/data/ipacfg-mgr/sdm845 hardware/qcom/sdm845/data/ipacfg-mgr
# guard use of kernel sources
# Change-Id: Ie8e892c5a7cca28cc58cbead88a9796ebc80a9f8
apply_gerrit_cl_commit refs/changes/23/834623/2 0f42902cbc526d6d5badcece2add39d5badd1537
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
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +eu
