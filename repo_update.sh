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

apply_gerrit_cl_commit() {
    _ref=$1
    _commit=$2
    # Check whether the commit is already stored
    if [ -z $(git rev-parse --quiet --verify $_commit^{commit}) ]
    # If not, fetch the ref from $LINK
    then
        git fetch $LINK $_ref && git cherry-pick FETCH_HEAD
    else
        git cherry-pick $_commit
    fi
}

if [ "$SKIP_SYNC" != "TRUE" ]; then
    pushd $ANDROOT/.repo/local_manifests
    git pull
    popd

    repo sync -j8 --current-branch --no-tags
fi

pushd $ANDROOT/art
LINK=$HTTP && LINK+="://android.googlesource.com/platform/art"
#ART: Add support for ARMv8.x features for ARM64.
#Change-Id: I3ae9db34507a3bb740fc0b7ceb335486dccdf460
apply_gerrit_cl_commit refs/changes/97/1112097/2 c6301193a5ccbb31499d6ab945b6d9626c4fc72e

#ART: Support kryo385 CPU.
#Change-Id: Iede5830093497abe753a34df3bc4913468be39d0
apply_gerrit_cl_commit refs/changes/29/837429/3 40ea08c79d92ddf46d496634ed4d5ec55380d51a
popd

pushd $ANDROOT/build/make/
LINK=$HTTP && LINK+="://android.googlesource.com/platform/build/make"
# Add A76 to known v8-a cores
# Change-Id: Ice05e7d4996252cfe4a9881a628c11b0f12cfd1b
apply_gerrit_cl_commit refs/changes/56/787356/3 e211f7cd2dc419af8142df2bcb062f7a8b126843

# Remove denver64 from make
# Change-Id: I8f28c7d6beaa5b0a7de9000ebea2f4d8e87f0381
apply_gerrit_cl_commit refs/changes/49/839749/3 6201b9eb5a91db2cb389838734e004a87505c807

# Enable armv8-2a supporting on 2nd arch. variant
# Change-Id: I1cd64ab0ad9b253ec3d109ebd1dbc7882011ce77
apply_gerrit_cl_commit refs/changes/21/824721/1 ead02eb87d6424b39cad9596cde53f643edadb51

# Support kryo385 CPU.
# Change-Id: Iede5830093497abe753a34df3bc4913468be39d0
apply_gerrit_cl_commit refs/changes/90/837390/3 f7dccc6bc077f9f95bcfad0e49f19f64aed44fc9
popd

pushd $ANDROOT/build/soong
LINK=$HTTP && LINK+="://android.googlesource.com/platform/build/soong"
# Add to support armv8-2a on 2nd arch. variant
# Change-Id: I755b8858726bd887068923123bad106aed7b1ec8
apply_gerrit_cl_commit refs/changes/02/824502/2 270ba75991b6c8f02123ad1b016346f7ca0fea33

# Add support for cortex-a76 in soong
# Change-Id: Iae0773d54e57b247c818d44f8044180d5a3f95a8
apply_gerrit_cl_commit refs/changes/56/787256/3 a31e2bda893910fa938099c4417e4b36d7513667

# Support Qualcomm Kryo 385 CPU variant.
# I62ffb46b1977b48446c6c1ca1400b1b39f7a8457
apply_gerrit_cl_commit refs/changes/60/831260/4 d3072b0c7cef7f5a217a055e66d85890c78620bc
popd

pushd $ANDROOT/hardware/qcom/data/ipacfg-mgr/sdm845
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/sdm845/data/ipacfg-mgr"
# guard use of kernel sources
# Change-Id: Ie8e892c5a7cca28cc58cbead88a9796ebc80a9f8
apply_gerrit_cl_commit refs/changes/23/834623/1 d8c88764440b0114b5f10bd9561a6b5dc4aab0e3
popd

pushd $ANDROOT/hardware/qcom/gps
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/gps"
# gps: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
apply_gerrit_cl_commit refs/changes/47/728147/2 147270f08ac33d737405afc555b3ddb6f1308336
# Revert "Remove etc folder under hardware/qcom/gps"
git revert --no-edit 484979c524067125b56d59afb102003ff48e3702
# Revert "Handle updating the carrier configuration"
git revert --no-edit f475797d3c031ae97a393fa3e899034836fe7ba6
# Revert "FR 46082 - SUPL Network Setup Improvements"
git revert --no-edit 35a95e0a9bc9aeab1bb1847180babda2da5fbf90
# Revert "DO NOT MERGE: Revert "Revert "sdm845: Add libprocessgroup dependency to set_sched_policy users""
git revert --no-edit db96236976a195bda833d821d584bc76ea4cdbae

LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/sdm845/gps"
# gps: sdm845: gnss: use correct format specifier in log
# Change-Id: I24ad0342d6d26f1c7fe2fcac451a71bbfba8bfe0
apply_gerrit_cl_commit refs/changes/39/804439/1 c1bdb439aaf7ecddd9f499dce5c7b56ea458cce4
popd

pushd $ANDROOT/hardware/qcom/audio
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/audio"
# audio: add sm8150 into support platform list
# Change-Id: Ic0e99aa9bd25790920f9cc13e42c0bd2de815fe6
git revert --no-edit 07f96d11649ffe2af61f83b4c7f22d12b407e03f
# hal: enable audio_hw flag for sdm710 platform
# Change-Id: I98fc64fc972dd073cde394aa59dafbde892ba06a
git revert --no-edit e56cd4bc673e7068d59803b9ac02f660e6bfd14e
# hal: Correct mixer control name for 3.5mm headphone
# Change-Id: I749609aabfed53e8adb3575695c248bf9a674874
git revert --no-edit 39a2b8a03c0a8a44940ac732f636d9cc1959eff2
# Add msm8976 tasha sound card detection to msm8916 HAL
# Change-Id: I9ac11e781cf627fa5efe586c96e48bfd04f32485
apply_gerrit_cl_commit refs/changes/49/728149/5 60f127241193694fa369adef134bdf3dd4bb9e8d
# post_proc: Enable post processing for msm8952
# Change-Id: If1162f8696f60ce68452249e5e546aec1d7aa5e1
apply_gerrit_cl_commit refs/changes/50/728150/4 3df44637ca88e0c3b3a8af17a052d65897385996
# Define default msm8998 pcm device for voicemmode call
# Change-Id: I9c7aa65bdcc0e460e287fd8e602b3a12e5be2191
apply_gerrit_cl_commit refs/changes/51/728151/3 798fc75d957367cb1b8d2c5634d19ac95087efd9
# hal: enable audio hal on sdm660
# Change-Id: I0edd5fa2c67eb7a96a44e907060dcbb273e983ac
apply_gerrit_cl_commit refs/changes/52/728152/4 93d7228217afa6a7b07b0df21d46b333847524e9
# post_proc: Enable post processing for sdm660
# Change-Id: I18b9cec56c6197b4465e8009c7e50aa95e111d32
apply_gerrit_cl_commit refs/changes/53/728153/3 9ea9d3f27686b5bccd75625c127518070d7a93e9
# hal: msm8916: Fix for vndk compilation errors
# Change-Id: Iffd8a3c00a2a1ad063e10c0ebf3ce9e88e3edea0
apply_gerrit_cl_commit refs/changes/14/777714/1 065ec9c4857fdd092d689a0526e0caeaaa6b1d72
popd

pushd $ANDROOT/hardware/qcom/media
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/media"
# msm8998: vdec: Add missing ifdefs for UBWC on DPB buffer decision
# Change-Id: I76131db5272b97016679c5bc0bf6ae099167cd03
apply_gerrit_cl_commit refs/changes/39/728339/1 b641243647a7cd3f382dd2be43b74f9d6b7f9310
# msm8998: mm-video-v4l2: enable compilation for both 3.18 kernel and 4.9 kernel
# Change-Id: If1eb2575dd80a1e6684c84e573baf78ae698bb20
apply_gerrit_cl_commit refs/changes/54/813054/1 01062d8acaae88b141893d69358d6c13e3495377
# msm8998: mm-video-v4l2: Renaming the AU-Delimiter params/extens
# Change-Id: I3feccfbb06e4e237a601a355ab2f2573a165ed3b
apply_gerrit_cl_commit refs/changes/55/813055/1 cb97584647999d7ea8df858f2c3f4bf04f408f34
popd

pushd $ANDROOT/hardware/qcom/media/sdm845
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/sdm845/media"
# Avoid missing dependency error for AOSP builds
# Change-Id: I19aa7a79f60bfd1182b5846ed54bf0fbf4fe0419
apply_gerrit_cl_commit refs/changes/80/832780/1 3a2fe3ec7974f9f1e9772d0009dc4df01937f237
# guard use of kernel sources
# Change-Id: I9b8cd5200cdfcc5d5ada39e6158383e7da221ae7
apply_gerrit_cl_commit refs/changes/84/832784/1 07a63defb34cd0a18849d4488ef11a8793e6cf3b
popd

pushd $ANDROOT/hardware/qcom/display
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/display"
# sdm: core: Update the mixer, framebuffer and display properly
# Change-Id: I8e1324787e35f2c675f1c8580901fb3fadc8f3c9
apply_gerrit_cl_commit refs/changes/09/729209/2 c62b4c1d5aeb39562d2241238082a73f39a7ea1b
# hwc2: Do not treat color mode errors as fatal at init
# Change-Id: I56926f320eb7719a22475793322d19244dd5d4d5
apply_gerrit_cl_commit refs/changes/10/729210/1 ae41c6d8047767f2cd84f6d4e7ef36c653bbb8f5
# msm8998: gralloc1: disable UBWC if video encoder client has no support
# Change-Id: I1ff2489b0ce8fe36a801881b848873e591077402
apply_gerrit_cl_commit refs/changes/11/729211/1 8dcf282bcec842ae633f43fc6dd1ecb397986d5c
# color_manager: Update display color api libname
# Change-Id: I3626975ddff8458c641dc60b3632581512f91b94
apply_gerrit_cl_commit refs/changes/12/729212/1 977eaf6520b189100df7729644a062a2fd9a6bc4
# msm8998: sdm: hwc2: Added property to disable skipping client color transform.
# Change-Id: I5e2508b2de391007f93064fe5bd506dd62050fbc
apply_gerrit_cl_commit refs/changes/13/729213/1 7f8016eb2f5b090847e70b69c08cae555add6e7f
popd

pushd $ANDROOT/hardware/qcom/bt
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bt"
# bt: use TARGET_BOARD_AUTO to override qcom hals
# Change-Id: I28898df1e8855347129039b5cb0d43975d3a5415
apply_gerrit_cl_commit refs/changes/69/728569/1 e0e30f0d46ef2ff5bcb707eaf47a596cb57b65af
popd

pushd $ANDROOT/hardware/qcom/bootctrl
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/qcom/bootctrl"
# bootcontrol: Add TARGET_USES_HARDWARE_QCOM_BOOTCTRL
# Change-Id: I958bcf29da2ea5914ac503e9d209c75ce44f1e51
git revert --no-edit f5db01c3b14d720f3d603cfb3b887d89c2b11b28
# Android.mk: add sdm710
# Change-Id: I82f2321d580cb2fdb15d2343e39abed5ccda50b1
git revert --no-edit a8e07aecb24898d7d2b49cb785b0c193a4b134b4
# Replace hardcoded build barrier with a generic one
# Change-Id: I34ee90a2818ad23cc6b9233bdde126a0965fae0d
apply_gerrit_cl_commit refs/changes/70/728570/2 0ae34c3a19fb0a1a0bd9775199692d550af4b8f5
popd

pushd $ANDROOT/hardware/nxp/nfc
LINK=$HTTP && LINK+="://android.googlesource.com/platform/hardware/nxp/nfc"
# hardware: nxp: Restore pn548 support
# Change-Id: Iafb0d31626d0a8b9faf22f5307ac8b0a5a9ded37
apply_gerrit_cl_commit refs/changes/61/744361/2 e3f2e87aaf9a24d61e3e3e350854d6da360696d8
# hardware: nxp: Restore pn547 support
# Change-Id: I498367f676f8c8d7fc13e849509d0d8a05ec89a8
apply_gerrit_cl_commit refs/changes/62/744362/5 6629cfdaf4c41f09b69874e5d0c40552c197a517
popd

pushd $ANDROOT/frameworks/base
LINK=$HTTP && LINK+="://android.googlesource.com/platform/frameworks/base"
# Add camera key long press handling
# Change-Id: I9e68032eee221c20608f0d2c491c2b308350f7f6
apply_gerrit_cl_commit refs/changes/15/727815/1 7913f55462b61c17b0700cf57d3f1a375bb4c565
# fwb: Add check for odm version
# Change-Id: Ifab6ca5c2f97840bb4192226f191e624267edb32
apply_gerrit_cl_commit refs/changes/75/728575/1 d6f654b013b00fa55b5c50f3f599df50847811bb
# Fix bug Device that can't support adoptable storage cannot read the sdcard.
# Change-Id: I7afe5078650fe646e79fced7456f90d4af8a449a
apply_gerrit_cl_commit refs/changes/05/728605/1 b6f563436ca1b1496bf6026453e5b805c856f9e6
# SystemUI: Implement burn-in protection for status-bar/nav-bar items
# Change-Id: I828dbd4029b4d3b1f2c86b682a03642e3f9aeeb9
apply_gerrit_cl_commit refs/changes/40/824340/1 6272c6244d2b007eb6ad08fb682d77612555d1ac
popd

# because "set -e" is used above, when we get to this point, we know
# all patches were applied successfully.
echo "+++ all patches applied successfully! +++"

set +e
