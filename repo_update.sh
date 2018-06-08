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
git cherry-pick 950a95836d5040e5d123a2128c85e8ac8b46588c
git cherry-pick 4d114f9e215fadc7d4f65f4d1ddccf95523ad6ee
git cherry-pick 04d99df80db386cad1e3f83f3d760920e6f61b32
git fetch $LINK refs/changes/90/497890/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/91/497891/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/build/soong
LINK=$HTTP && LINK+="://android.googlesource.com/platform/build/soong"
git revert --no-edit 8cede07e698cc1a15257a6b5dd653488e2bbf49e
git revert --no-edit 0f1bd9d3d73f1d1a673c23d5b180172c8c4605db
git revert --no-edit e54d01029b8e2743254740a7a2ca167c6647e5d2
git revert --no-edit 10b40b087cb9b7ead39da1e9fc6b7a85ecb4a901
git revert --no-edit 756b1c2343ed019ad59868c81491ea1eb7d42c57
git revert --no-edit 95421a4a776c5119d7d0729dd2efe05568d19f2b
git revert --no-edit 8ecfbadcc3fb1d1bd29a36e4e9dd6417399adaf3
git revert --no-edit 0417699bbbd4151711e09925f3c72cbf3b8e81a5
git cherry-pick ae4fc1840653fd5598f81d33ac33a00d09b94607
git cherry-pick ac01ff5447518986f778be5b5c5a7bb0bf354e9c
git cherry-pick 5df73d02ce2ccf373029ba082d5a1fac82dfa33e
git cherry-pick b916b80bf301545595a8263776180c1db90a9ccc
git cherry-pick 1783a2f3e87ce191d5a22b0125aab6111a562a6c
git cherry-pick fff256f817213482c6b04ede2882aa9952d9948b
git cherry-pick 5cfd70952954ed5cffa270d9733df802123b1ea0
git cherry-pick 0906f17f7e8bf0e76cb8511669e8fc8d5f6f3794
git cherry-pick fa7e8af921afae02be39957c779bb11aa59f3699
git cherry-pick 1d9aa26d445cd5407aea0831e6b67fb37dfc1d05
git cherry-pick 5916657a96ce9fe90d2d2959472a8398f9ed7e58
git cherry-pick 41f5d58cd5cb4ee5021ab1ad574342a1d19c5d3e
git cherry-pick 8ecfbadcc3fb1d1bd29a36e4e9dd6417399adaf3
git cherry-pick 95421a4a776c5119d7d0729dd2efe05568d19f2b
git cherry-pick 756b1c2343ed019ad59868c81491ea1eb7d42c57
git cherry-pick 10b40b087cb9b7ead39da1e9fc6b7a85ecb4a901
git cherry-pick 0f1bd9d3d73f1d1a673c23d5b180172c8c4605db
git cherry-pick 8cede07e698cc1a15257a6b5dd653488e2bbf49e
git cherry-pick e28f4e2acfcca00766080d294daa75ae2efb5853
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
git cherry-pick 2804ee1ebc305ae91f95b3411cc70da69ae2635d
git cherry-pick 305b9daae60215de907f2e4913a20e02fd2b0c70
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
git cherry-pick f6aae037da61d2ec5327e157c0489dec1231f5c2
git fetch $LINK refs/changes/91/294291/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/63/573163/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/56/535256/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/43/576643/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/41/602841/3 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/42/602842/1 && git cherry-pick FETCH_HEAD
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
