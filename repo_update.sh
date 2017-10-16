cd .repo/local_manifests
git pull
cd ../..

repo sync -j8 --current-branch --no-clone-bundle --no-tags

cd bionic
git fetch http://android.googlesource.com/platform/bionic refs/changes/53/363153/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/bionic refs/changes/92/368092/2 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/bionic refs/changes/14/265214/21 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/bionic refs/changes/90/497890/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/bionic refs/changes/91/497891/2 && git cherry-pick FETCH_HEAD
cd ../build/soong
git fetch http://android.googlesource.com/platform/build/soong refs/changes/54/266354/28 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/build/soong refs/changes/93/266393/16 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/build/soong refs/changes/13/365413/2 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/build/soong refs/changes/12/367312/2 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/build/soong refs/changes/32/367332/3 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/build/soong refs/changes/92/367392/2 && git cherry-pick FETCH_HEAD
cd ../../hardware/qcom/gps
git fetch http://android.googlesource.com/platform/hardware/qcom/gps refs/changes/37/464137/1 && git cherry-pick FETCH_HEAD
cd ../audio
git fetch http://android.googlesource.com/platform/hardware/qcom/audio refs/changes/91/294291/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/audio refs/changes/86/333386/1 && git cherry-pick FETCH_HEAD
cd ../media
git fetch http://android.googlesource.com/platform/hardware/qcom/media refs/changes/39/422439/2 && git cherry-pick FETCH_HEAD
cd ../display
git fetch http://android.googlesource.com/platform/hardware/qcom/display refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/display refs/changes/36/437236/1 && git cherry-pick FETCH_HEAD
cd ../bt
git fetch http://android.googlesource.com/platform/hardware/qcom/bt refs/changes/17/478117/1 && git cherry-pick FETCH_HEAD
cd ../../../system/core
git fetch http://android.googlesource.com/platform/system/core refs/changes/37/469437/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/system/core refs/changes/92/497892/2 && git cherry-pick FETCH_HEAD
cd ../../frameworks/av
git fetch http://android.googlesource.com/platform/frameworks/av refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD
cd ../../packages/inputmethods/LatinIME
git fetch http://android.googlesource.com/platform/packages/inputmethods/LatinIME refs/changes/78/469478/1 && git cherry-pick FETCH_HEAD
cd ../../../
