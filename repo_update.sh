cd .repo/local_manifests
git pull
cd ../..

repo sync -j8

cd external/toybox
git fetch http://android.googlesource.com/platform/external/toybox refs/changes/74/265074/1 && git cherry-pick FETCH_HEAD
git cherry-pick d3e8dd1bf56afc2277960472a46907d419e4b3da
git cherry-pick 1c028ca33dc059a9d8f18daafcd77b5950268f41
git cherry-pick cb49c305e3c78179b19d6f174ae73309544292b8
cd ../libnfc-nci
git fetch http://android.googlesource.com/platform/external/libnfc-nci refs/changes/52/371052/1 && git cherry-pick FETCH_HEAD
cd ../../hardware/qcom/bt
git fetch http://android.googlesource.com/platform/hardware/qcom/bt refs/changes/99/422499/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/bt refs/changes/00/422500/1 && git cherry-pick FETCH_HEAD
cd ../audio
git fetch http://android.googlesource.com/platform/hardware/qcom/audio refs/changes/91/294291/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/audio refs/changes/35/274235/9 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/audio refs/changes/86/333386/1 && git cherry-pick FETCH_HEAD
cd ../display
git revert --no-edit 51b4299f42c61d3a919c8e86c38a85f40902226b
git revert --no-edit b7d1a389b00370fc9d2a7db1268ce26271ead7e2
git revert --no-edit f026d04dde743a0524235ae57e2ce8ac5364d44b
git revert --no-edit 3261eb2236252f9f2510c008fad451411a780b3b
git fetch http://android.googlesource.com/platform/hardware/qcom/display refs/changes/54/274454/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/display refs/changes/55/274455/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/display refs/changes/35/437235/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/display refs/changes/36/437236/1 && git cherry-pick FETCH_HEAD
cd ../media
git fetch http://android.googlesource.com/platform/hardware/qcom/media refs/changes/39/422439/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/media refs/changes/79/422379/1 && git cherry-pick FETCH_HEAD
cd ../keymaster
git revert --no-edit 583ecf5ed2a4be0d05229b8c6726680c3836be8b
git fetch http://android.googlesource.com/platform/hardware/qcom/keymaster refs/changes/70/212570/5 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/hardware/qcom/keymaster refs/changes/80/212580/2 && git cherry-pick FETCH_HEAD
cd ../../../system/core
git fetch http://android.googlesource.com/platform/system/core refs/changes/52/269652/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/system/core refs/changes/12/373812/1 && git cherry-pick FETCH_HEAD
cd ../extras
git cherry-pick c71eaf37486bed9163ad528f51de29dd56b34fd2
cd ../bt
git cherry-pick 4e0f8cd65b4fbfd22612d1467b1c4df03829cfd6
git cherry-pick 69d7436c605222ba98604533d79b6861bd434e9b
git cherry-pick d9eebf7a4da76764203779e35f3d288e75b7521b
git cherry-pick de9e5d56c8d0e8f5033dd9c3d3b1d7f013709fe8
git cherry-pick 7ea6db20a9a1225f58fd507b51501f8c21d28c75
git cherry-pick ff6e31a55d3904770cd3cf6b2cd62f607e841dc2
git cherry-pick 8952869a7e688440f9021da0f4cdf926f86149b6
cd ../../packages/apps/Music
git cherry-pick 6036ce6127022880a3d9c99bd15db4c968f3e6a3
cd ../../../frameworks/av
git fetch http://android.googlesource.com/platform/frameworks/av refs/changes/69/343069/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/frameworks/av refs/changes/70/343070/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/frameworks/av refs/changes/71/343071/1 && git cherry-pick FETCH_HEAD
git fetch http://android.googlesource.com/platform/frameworks/av refs/changes/92/384692/2 && git cherry-pick FETCH_HEAD
cd ../../
