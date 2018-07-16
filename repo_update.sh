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

pushd $ANDROOT/bionic
LINK=$HTTP && LINK+="://android.googlesource.com/platform/bionic"
git fetch $LINK refs/changes/59/555059/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/22/553222/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/bootable/recovery
LINK=$HTTP && LINK+="://android.googlesource.com/platform/bootable/recovery"
git fetch $LINK refs/changes/52/496452/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
git fetch $LINK refs/changes/19/642919/5 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
git fetch $LINK refs/changes/37/464137/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
git fetch $LINK refs/changes/08/708808/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/09/708809/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/56/535256/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/43/576643/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/41/602841/4 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/42/602842/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/10/708810/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
git fetch $LINK refs/changes/55/522855/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/15/708815/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/16/708816/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/17/708817/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/42/713242/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/43/713243/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
git fetch $LINK refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/42/576642/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/38/602838/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/79/645379/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/12/708812/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/13/708813/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/14/708814/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/09/716909/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
git fetch $LINK refs/changes/84/573184/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bootctrl
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bootctrl"
git fetch $LINK refs/changes/11/708811/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/core
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/core"
git fetch $LINK refs/changes/21/553221/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/41/501741/2 && git cherry-pick FETCH_HEAD
git revert --no-edit 1d540dd0f44c1c7d40878f6a7bb447e85e6207ad
git fetch $LINK refs/changes/37/469437/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/frameworks/av
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/av"
git fetch $LINK refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/packages/apps/Nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/apps/Nfc"
git fetch $LINK refs/changes/62/666362/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/packages/inputmethods/LatinIME
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/inputmethods/LatinIME"
git fetch $LINK refs/changes/78/469478/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/nfc"
git fetch $LINK refs/changes/17/515517/10 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/15/533315/4 && git cherry-pick FETCH_HEAD
popd
