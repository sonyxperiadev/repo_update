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
git fetch $LINK refs/changes/50/234150/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/53/236953/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/90/497890/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/01/503201/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/bootable/recovery
LINK=$HTTP && LINK+="://android.googlesource.com/platform/bootable/recovery"
git fetch $LINK refs/changes/15/538015/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/external/toybox
LINK=$HTTP && LINK+="://android.googlesource.com/platform/external/toybox"
git fetch $LINK refs/changes/74/265074/1 && git cherry-pick FETCH_HEAD
git cherry-pick d3e8dd1bf56afc2277960472a46907d419e4b3da
git cherry-pick 1c028ca33dc059a9d8f18daafcd77b5950268f41
git cherry-pick cb49c305e3c78179b19d6f174ae73309544292b8
popd

pushd $ANDROOT/external/iproute2
LINK=$HTTP && LINK+="://android.googlesource.com/platform/external/iproute2"
git cherry-pick 04cd308001d732a1c8e5d244daba37c56a4641b0
popd

pushd $ANDROOT/external/libnfc-nci
LINK=$HTTP && LINK+="://android.googlesource.com/platform/external/libnfc-nci"
git fetch $LINK refs/changes/52/371052/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
git fetch $LINK refs/changes/99/422499/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/00/422500/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
git cherry-pick f1346ce3f446e6a89f39748bf319949fb54036a3
git fetch $LINK refs/changes/91/294291/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/86/333386/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/55/535255/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
git revert --no-edit 51b4299f42c61d3a919c8e86c38a85f40902226b
git revert --no-edit b7d1a389b00370fc9d2a7db1268ce26271ead7e2
git revert --no-edit f026d04dde743a0524235ae57e2ce8ac5364d44b
git revert --no-edit 3261eb2236252f9f2510c008fad451411a780b3b
git fetch $LINK refs/changes/54/274454/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/55/274455/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/36/437236/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
git fetch $LINK refs/changes/39/422439/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/79/422379/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/hardware/qcom/keymaster
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/keymaster"
git revert --no-edit 583ecf5ed2a4be0d05229b8c6726680c3836be8b
git fetch $LINK refs/changes/70/212570/5 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/80/212580/2 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/core
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/core"
git fetch $LINK refs/changes/52/269652/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/12/373812/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/75/537175/1 && git cherry-pick FETCH_HEAD
popd

pushd $ANDROOT/system/extras
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/extras"
git cherry-pick c71eaf37486bed9163ad528f51de29dd56b34fd2
popd

pushd $ANDROOT/system/netd
LINK=$HTTP && LINK+="://android.googlesource.com/platform/system/netd"
git cherry-pick 2b078678aafceeefea6a70e96ab8ddefe515d027
git cherry-pick 882e467ff7b83de868fa0b9a9beb9036bf14aede
popd

pushd $ANDROOT/packages/apps/Camera2
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/apps/Camera2"
git cherry-pick 8b17de0f4321fd981da98c64ad8a379ed6c0432a
popd

pushd $ANDROOT/packages/apps/Music
LINK=$HTTP && LINK+="://android.googlesource.com/platform/packages/apps/Music"
git cherry-pick 6036ce6127022880a3d9c99bd15db4c968f3e6a3
popd

pushd $ANDROOT/frameworks/av
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/av"
git fetch $LINK refs/changes/69/343069/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/70/343070/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/71/343071/1 && git cherry-pick FETCH_HEAD
git fetch $LINK refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD
popd
