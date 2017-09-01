cd .repo/local_manifests
git pull
cd ../..

repo sync -j8

cd hardware/qcom/gps
git fetch http://android.googlesource.com/platform/hardware/qcom/gps refs/changes/37/464137/1 && git cherry-pick FETCH_HEAD
cd ../audio
git fetch http://android.googlesource.com/platform/hardware/qcom/audio refs/changes/91/294291/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/audio refs/changes/86/333386/1 && git cherry-pick FETCH_HEAD
cd ../media
git fetch http://android.googlesource.com/platform/hardware/qcom/media refs/changes/39/422439/2 && git cherry-pick FETCH_HEAD
cd ../display
git fetch http://android.googlesource.com/platform/hardware/qcom/display refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/display refs/changes/36/437236/1 && git cherry-pick FETCH_HEAD
cd ../../../system/core
git fetch http://android.googlesource.com/platform/system/core refs/changes/37/469437/1 && git cherry-pick FETCH_HEAD
cd ../../frameworks/av
git fetch http://android.googlesource.com/platform/frameworks/av refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD
cd ../../

