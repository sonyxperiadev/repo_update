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

if [ "$SKIP_SYNC" != "TRUE" ]; then
    repo sync -j8 --current-branch --no-tags
fi

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
git revert --no-edit f85d0932e27d673669cebf0776ba8a647a68905d
git fetch $LINK refs/changes/47/728147/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/05/731505/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/06/731506/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/07/731507/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
git fetch $LINK refs/changes/49/728149/5 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/50/728150/4 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/51/728151/3 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/52/728152/4 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/53/728153/3 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
git fetch $LINK refs/changes/39/728339/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/42/728342/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/43/728343/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/44/728344/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/65/728565/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/66/728566/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/67/728567/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/94/732594/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
git fetch $LINK refs/changes/09/729209/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/10/729210/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/11/729211/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/12/729212/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/13/729213/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/08/729208/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/14/729214/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/15/729215/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/16/729216/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
git fetch $LINK refs/changes/69/728569/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bootctrl
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bootctrl"
git fetch $LINK refs/changes/70/728570/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
git fetch $LINK refs/changes/15/727815/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/75/728575/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/05/728605/1 && git cherry-pick FETCH_HEAD
popd
