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
git fetch $LINK refs/changes/47/728147/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/sdm845/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
git fetch $LINK refs/changes/47/728147/2 && git cherry-pick FETCH_HEAD
git revert --no-edit 484979c524067125b56d59afb102003ff48e3702
git revert --no-edit f475797d3c031ae97a393fa3e899034836fe7ba6
git revert --no-edit 35a95e0a9bc9aeab1bb1847180babda2da5fbf90
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
git fetch $LINK refs/changes/49/728149/5 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/50/728150/4 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/51/728151/3 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/52/728152/4 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/53/728153/3 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/14/777714/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
git fetch $LINK refs/changes/39/728339/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
git fetch $LINK refs/changes/09/729209/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/10/729210/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/11/729211/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/12/729212/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/13/729213/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
git fetch $LINK refs/changes/69/728569/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bootctrl
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bootctrl"
git revert --no-edit a8e07aecb24898d7d2b49cb785b0c193a4b134b4
git fetch $LINK refs/changes/70/728570/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/nxp/nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/nxp/nfc"
git fetch $LINK refs/changes/61/744361/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/62/744362/5 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
git fetch $LINK refs/changes/15/727815/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/75/728575/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/05/728605/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/core
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/core"
git fetch $LINK refs/changes/01/741001/2 && git cherry-pick FETCH_HEAD
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +e
