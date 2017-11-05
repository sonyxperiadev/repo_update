#!/bin/bash

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

pushd $PWD/.repo/local_manifests
git pull
popd

repo sync -j8

pushd $PWD/bionic
git fetch https://android.googlesource.com/platform/bionic refs/changes/53/363153/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/bionic refs/changes/92/368092/2 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/bionic refs/changes/14/265214/21 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/bionic refs/changes/90/497890/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/bionic refs/changes/91/497891/2 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/build/soong
git fetch https://android.googlesource.com/platform/build/soong refs/changes/54/266354/28 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/build/soong refs/changes/93/266393/16 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/build/soong refs/changes/13/365413/2 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/build/soong refs/changes/12/367312/2 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/build/soong refs/changes/32/367332/3 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/build/soong refs/changes/92/367392/2 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/bootable/recovery
git cherry-pick 846012fc444e6076dabf874ed8cbdab358c2e0fb
git fetch https://android.googlesource.com/platform/bootable/recovery refs/changes/35/517735/2 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/external/wpa_supplicant_8
git fetch https://android.googlesource.com/platform/external/wpa_supplicant_8 refs/changes/00/512300/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/external/wpa_supplicant_8 refs/changes/01/512301/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/external/wpa_supplicant_8 refs/changes/02/512302/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/external/wpa_supplicant_8 refs/changes/03/512303/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/external/wpa_supplicant_8 refs/changes/04/512304/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/external/wpa_supplicant_8 refs/changes/05/512305/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/external/wpa_supplicant_8 refs/changes/06/512306/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/external/wpa_supplicant_8 refs/changes/07/512307/1 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/hardware/qcom/gps
git fetch https://android.googlesource.com/platform/hardware/qcom/gps refs/changes/37/464137/1 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/hardware/qcom/audio
git fetch https://android.googlesource.com/platform/hardware/qcom/audio refs/changes/91/294291/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/hardware/qcom/audio refs/changes/86/333386/1 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/hardware/qcom/media
git fetch https://android.googlesource.com/platform/hardware/qcom/media refs/changes/39/422439/2 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/hardware/qcom/media refs/changes/55/522855/1 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/hardware/qcom/display
git fetch https://android.googlesource.com/platform/hardware/qcom/display refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/hardware/qcom/display refs/changes/36/437236/1 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/hardware/qcom/bt
git fetch https://android.googlesource.com/platform/hardware/qcom/bt refs/changes/17/478117/1 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/system/core
git fetch https://android.googlesource.com/platform/system/core refs/changes/37/469437/1 && git cherry-pick FETCH_HEAD
git fetch https://android.googlesource.com/platform/system/core refs/changes/92/497892/2 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/frameworks/av
git fetch https://android.googlesource.com/platform/frameworks/av refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD
popd

pushd $PWD/packages/inputmethods/LatinIME
git fetch https://android.googlesource.com/platform/packages/inputmethods/LatinIME refs/changes/78/469478/1 && git cherry-pick FETCH_HEAD
popd
