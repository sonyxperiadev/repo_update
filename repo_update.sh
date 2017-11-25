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

repo sync -j8

pushd $ANDROOT/bionic
LINK=$HTTP && LINK+="://android.googlesource.com/platform/bionic"
git fetch $LINK refs/changes/53/363153/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/92/368092/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/14/265214/21 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/90/497890/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/91/497891/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/build/soong
LINK=$HTTP && LINK+="://android.googlesource.com/platform/build/soong"
git fetch $LINK refs/changes/54/266354/28 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/93/266393/16 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/13/365413/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/12/367312/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/32/367332/3 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/92/367392/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/bootable/recovery
LINK=$HTTP && LINK+="://android.googlesource.com/platform/bootable/recovery"
git cherry-pick 846012fc444e6076dabf874ed8cbdab358c2e0fb
git fetch $LINK refs/changes/35/517735/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/external/wpa_supplicant_8
LINK=$HTTP && LINK+="://android.googlesource.com/platform/external/wpa_supplicant_8"
git fetch $LINK refs/changes/00/512300/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/01/512301/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/02/512302/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/03/512303/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/04/512304/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/05/512305/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/06/512306/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/07/512307/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
git fetch $LINK refs/changes/37/464137/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
git fetch $LINK refs/changes/91/294291/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/86/333386/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/56/535256/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
git fetch $LINK refs/changes/39/422439/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/55/522855/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
git fetch $LINK refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/36/437236/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
git fetch $LINK refs/changes/17/478117/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/core
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/core"
git fetch $LINK refs/changes/37/469437/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/92/497892/2 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/75/537175/1 && git cherry-pick FETCH_HEAD
git cherry-pick d266d37e4cb6d0b31eb9422b73f051632ea7365f
popd

pushd $ANDROOT/frameworks/av
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/av"
git fetch $LINK refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/packages/inputmethods/LatinIME
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/inputmethods/LatinIME"
git fetch $LINK refs/changes/78/469478/1 && git cherry-pick FETCH_HEAD
popd
