{ lib, pkgs, home, ... }:
# To get rid of VR error:
# sudo setcap CAP_SYS_NICE+ep ~/.local/share/Steam/steamapps/common/SteamVR/bin/linux64/vrcompositor-launcher
# Extra args for steamvr launch: ~/.local/share/Steam/steamapps/common/SteamVR/bin/vrmonitor.sh %command% 
{
  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
  # Extra dependencies for steamVR
  programs.steam.package = pkgs.steam.override {
    extraPkgs = pkgs: with pkgs; [ 
      libcap 
      procps
      usbutils
    ];
  };
}
