#!/bin/bash

    #WINE STAGING
    cd wine-staging
    git reset --hard HEAD
    git clean -xdf

    # reenable pulseaudio patches
    patch -Np1 < ../patches/wine-hotfixes/staging-reenable-pulse.patch
    patch -RNp1 < ../patches/wine-hotfixes/staging-pulseaudio-reverts.patch

    # protonify syscall emulation
    patch -Np1 < ../patches/wine-hotfixes/protonify_stg_syscall_emu.patch
    cd ..

    #WINE
    cd wine
    git reset --hard HEAD
    git clean -xdf

    #echo "revert d171d1116764260f4ae272c69b54e5dfd13c6835 which breaks the wayland driver"
    #git revert --no-commit d171d1116764260f4ae272c69b54e5dfd13c6835

    # https://bugs.winehq.org/show_bug.cgi?id=49990
    echo "revert bd27af974a21085cd0dc78b37b715bbcc3cfab69 which breaks some game launchers"
    git revert --no-commit bd27af974a21085cd0dc78b37b715bbcc3cfab69
    
    # revert this because it breaks controllers on some platforms
    # https://github.com/Frogging-Family/wine-tkg-git/issues/248#issuecomment-760471607
    echo "revert e4fbae832c868e9fcf5a91c58255fe3f4ea1cb30 which breaks controller detection on some distros"
    git revert --no-commit e4fbae832c868e9fcf5a91c58255fe3f4ea1cb30

    echo "temporary pulseaudio reverts"
    git revert --no-commit 2e64d91428757eaa88475b49bf50922cda603b59
    git revert --no-commit f77af3dd6324fadaf153062d77b51f755f71faea
    git revert --no-commit ce151dd681fe5ee80daba96dce12e37d6846e152
    git revert --no-commit 77813eb7586779df0fb3b700000a17e339fd5ce3
    git revert --no-commit d8e9621cfad50596378283704dfb1e6926d77ed8
    git revert --no-commit a4149d53f734bf898087e22170eab5bed9a423d1
    git revert --no-commit b4c7823bbb6a792098131f5572506784c8ed0f35
    git revert --no-commit 70f59eb179d6a1c1b4dbc9e0a45b5731cd260793
    git revert --no-commit e19d97ff4e2f5a7800d6df77b8acce95130b84c3
    git revert --no-commit 4432b66e372caf0096df56f45502d7dea1f1800c
    git revert --no-commit 6a6296562f536ed10d221f0df43ef30bbd674cb2
    git revert --no-commit aba40bd50a065b3ac913dbc1263c38535fb5d9e7
    git revert --no-commit bf74f36350c92daae84623dc0bd0530c212bb908
    git revert --no-commit 1518e73b23211af738ae448a80466c0199f24419
    git revert --no-commit 44e4132489c28b429737be022f6d4044c5beab3e
    git revert --no-commit a6131544e87c554f70c21a04fb4697d8e1f508d5
    git revert --no-commit 80b996c53c767fef4614f097f14c310285d9c081
    git revert --no-commit 459e911b653c7519a335661a6c0b0894e86d2f1a
    git revert --no-commit 42d826bc8c1d625ed2985ff06c2cd047209a1916
    git revert --no-commit 30c17619e5401618122ca330cf0909f49b170a59
    git revert --no-commit af84907ccad3e28f364ecfaa75ccb5fedf7f5a42
    git revert --no-commit a5997bece730beb8ab72d66b824ed2a1cb92c254
    git revert --no-commit 24a7c33fc1ad6dbab489284cfb6dba4130297ddb
    git revert --no-commit 8cb88173d87efedce8c345beea05641f5617d857
    git revert --no-commit 505d4b8b14913f3abd362bf27272e6b239cb6ce4
    git revert --no-commit 638455136b4d30b853b02b77a2f33dc61c60b267
    git revert --no-commit 13cac6287c454146eff73aabc4b92b5c8f76d4df
    git revert --no-commit d7b957654d4739b8dd07c91f051b7940f416ef42
    git revert --no-commit 8ea23d0d44ced0ce7dadc9b2546cbc56f6bce364
    git revert --no-commit 0b0ae164f4ccebf4b5bc1bb1529a90786d2d5941
    git revert --no-commit 131b7fd5e16a3da17aed28e86933074c5d663d9f
    git revert --no-commit 8060e56b26add8eafffb211119798569ea3188ff
    git revert --no-commit bca0706f3a93fa0a57f4dbdc6ae541e8f25afb34
    git revert --no-commit b1ddfca16e4696a52adf2bdd8333eeffb3c6170c
    git revert --no-commit a5d4079c8285c10ab2019c9fd9d19a6b22babb76
    git revert --no-commit ebd344f2922f4044117904e024a0a87576a3eff1
    git revert --no-commit 0eeefec6c56084a0677403aee46493e2c03a1dca
    git revert --no-commit 5477f2b0156d16952a286dd0df148c2f60b71fe6
    git revert --no-commit fa097243e06b3855a240c866a028add722025ead
    git revert --no-commit 8df72bade54d1ef7a6d9e79f20ee0a2697019c13
    git revert --no-commit e264ec9c718eb66038221f8b533fc099927ed966
    git revert --no-commit d3673fcb034348b708a5d8b8c65a746faaeec19d

    # disable these when using proton's gamepad patches
    # -W dinput-SetActionMap-genre \
    # -W dinput-axis-recalc \
    # -W dinput-joy-mappings \
    # -W dinput-reconnect-joystick \
    # -W dinput-remap-joystick \

    # these cause window freezes/hangs with origin
    # -W winex11-_NET_ACTIVE_WINDOW \
    # -W winex11-WM_WINDOWPOSCHANGING \

    # this needs to be disabled of disabling the winex11 patches above because staging has them set as a dependency.
    # -W imm32-com-initialization

    # instead, we apply it manually:
    # patch -Np1 < ../patches/wine-hotfixes/imm32-com-initialization_no_net_active_window.patch

    echo "applying staging patches"
    ../wine-staging/patches/patchinstall.sh DESTDIR="." --all \
    -W winex11-_NET_ACTIVE_WINDOW \
    -W winex11-WM_WINDOWPOSCHANGING \
    -W imm32-com-initialization \
    -W bcrypt-ECDHSecretAgreement \
    -W ntdll-NtAlertThreadByThreadId

    # apply this manually since imm32-com-initialization is disabled in staging.
    patch -Np1 < ../patches/wine-hotfixes/imm32-com-initialization_no_net_active_window.patch

    ### GAME PATCH SECTION ###    
    echo "mech warrior online"
    patch -Np1 < ../patches/game-patches/mwo.patch

    echo "assetto corsa"
    patch -Np1 < ../patches/game-patches/assettocorsa-hud.patch

    # TODO: Add game-specific check
    echo "mk11 patch"
    patch -Np1 < ../patches/game-patches/mk11.patch

    # BLOPS2 uses CEG which does not work in proton. Disabled for now
    echo "blackops 2 fix"
    patch -Np1 < ../patches/game-patches/blackops_2_fix.patch

    echo "killer instinct vulkan fix"
    patch -Np1 < ../patches/game-patches/killer-instinct-winevulkan_fix.patch

    ### END GAME PATCH SECTION ###
    
    ### PROTON PATCH SECTION ###
    
    echo "clock monotonic"
    patch -Np1 < ../patches/proton/01-proton-use_clock_monotonic.patch
    
    #WINE FSYNC
    echo "applying fsync patches"
    patch -Np1 < ../patches/proton/03-proton-fsync_staging.patch

    echo "LAA"
    patch -Np1 < ../patches/proton/04-proton-LAA_staging.patch

    echo "protonify"
    patch -Np1 < ../patches/proton/10-proton-protonify_staging.patch

    echo "protonify-audio"
    patch -Np1 < ../patches/proton/11-proton-pa-staging.patch

#    currently disabled in favor of wine's implementation
#    echo "proton gamepad additions"
#    patch -Np1 < ../patches/proton/15-proton-gamepad-additions.patch

    echo "amd ags"
    patch -Np1 < ../patches/proton/18-proton-amd_ags.patch

    echo "valve rdr2 fixes"
    patch -Np1 < ../patches/proton/25-proton-rdr2-fixes.patch
    
    echo "apply staging bcrypt patches on top of rdr2 fixes"
    patch -Np1 < ../patches/wine-hotfixes/0001-bcrypt-Allow-multiple-backends-to-coexist.patch
    patch -Np1 < ../patches/wine-hotfixes/0002-bcrypt-Implement-BCryptSecretAgreement-with-libgcryp.patch

    echo "set prefix win10"
    patch -Np1 < ../patches/proton/28-proton-win10_default.patch

#    only needed with proton's gamepad patches
#    echo "proton udev container patches"
#    patch -Np1 < ../patches/proton/35-proton-udev_container_patches.patch

#    only needed with proton's gamepad patches
#    echo "proton overlay patches"
#    patch -Np1 < ../patches/proton/36-proton-overlay_fixes.patch

    echo "mouse focus fixes"
    patch -Np1 < ../patches/proton/38-proton-mouse-focus-fixes.patch

    echo "CPU topology overrides"
    patch -Np1 < ../patches/proton/39-proton-cpu-topology-overrides.patch

    echo "proton futex2 patches"
    patch -Np1 < ../patches/proton/40-proton-futex2.patch

    ## VULKAN-CENTRIC PATCHES

    echo "fullscreen hack"
    patch -Np1 < ../patches/proton/41-valve_proton_fullscreen_hack-staging-tkg.patch

#    disabled for now, needs rebase. only used for vr anyway
#    echo "proton openxr patches"
#    patch -Np1 < ../patches/proton/37-proton-OpenXR-patches.patch

    ## END VULKAN-CENTRIC PATCHES

    ### END PROTON PATCH SECTION ###

    ### LUTRIS PATCH SECTION ###
    echo "create Lutris custom registry overrides sections"
    patch -Np1 < ../patches/lutris/LutrisClient-registry-overrides-section.patch

    echo "msvcrt overrides"
    patch -Np1 < ../patches/lutris/19-lutris-msvcrt_nativebuiltin.patch

    echo "atiadlxx needed for cod games"
    patch -Np1 < ../patches/lutris/20-lutris-atiadlxx.patch

    echo "lutris registry entries"
    patch -Np1 < ../patches/lutris/21-lutris-01_wolfenstein2_registry.patch
    patch -Np1 < ../patches/lutris/22-lutris-02_rdr2_registry.patch
    patch -Np1 < ../patches/lutris/23-lutris-03_nier_sekiro_ds3_registry.patch
    patch -Np1 < ../patches/lutris/24-lutris-04_cod_registry.patch
    patch -Np1 < ../patches/lutris/32-lutris-05_spellforce_registry.patch
    patch -Np1 < ../patches/lutris/33-lutris-06_shadow_of_war_registry.patch
    patch -Np1 < ../patches/lutris/41-lutris-07_nfs_registry.patch
    patch -Np1 < ../patches/lutris/45-lutris-08_FH4_registry.patch
    #patch -Np1 < ../patches/lutris/46-lutris-09_nvapi_registry.patch

    ### END LUTRIS PATCH SECTION ###

    ### WINE PATCH SECTION ###

     # only use when staging version is disabled
    echo "mfplat additions"
    patch -Np1 < ../patches/wine-hotfixes/mfplat-godfall-hotfix.patch

    # these are applied out of order since guy's mfplat patches are based on vanilla wine
    echo "proton-specific mfplat video conversion patches"
    patch -Np1 < ../patches/proton/34-proton-winegstreamer_updates.patch

    # borderlands 3 fixer
    patch -Np1 < ../patches/wine-hotfixes/205333

    # pending upstream wine fixes
    
    # more mfplat fixes

    # additional pending mfplat fonv audio loop fix
    patch -Np1 < ../patches/wine-hotfixes/205277

    # FH4 performance frequency patch
    patch -Np1 < ../patches/wine-hotfixes/204113

    echo "proton QPC performance patch"
    patch -Np1 < ../patches/wine-hotfixes/proton_QPC.patch

    echo "proton LFH performance patch"
    patch -Np1 < ../patches/wine-hotfixes/proton_LFH.patch

    echo "Horizon Zero Dawn animations fix"
    patch -Np1 < ../patches/wine-hotfixes/HZD_animations_pr112.patch

    echo "pending roblox fix"
    patch -Np1 < ../patches/wine-hotfixes/pending_roblox_hotfix.patch


    # BF4 ping fix
    patch -Np1 < ../patches/wine-hotfixes/207990

    # RPGMaker VX fix
    patch -Np1 < ../patches/wine-hotfixes/rpgmaker.patch

    # bnet unfucker
    patch -Np1 < ../patches/wine-hotfixes/pending_upstream_battlenet_unfucker.patch

    # server cpu usage unfucker
    patch -Np1 < ../patches/wine-hotfixes/pending_upstream_server_cpu_unfucker.patch

    # this is needed for battle.net
#    patch -RNp1 < ../patches/wine-hotfixes/revert-ws2_32-Reimplement-select-on-top-of-IOCTL_AFD_POL.patch

    #disabled, still horribly broken
#    patch -Np1 < ../patches/wine-hotfixes/wine_wayland_driver.patch

    # need to run these after applying patches
    ./dlls/winevulkan/make_vulkan
    ./tools/make_requests
    autoreconf -f

    ### END WINEPATCH SECTION ###

    #WINE CUSTOM PATCHES
    #add your own custom patch lines below

    #end
