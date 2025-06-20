{ pkgs, ... }:
{
  programs.alvr = {
    package = pkgs.unstable.alvr;
    enable = true;
    openFirewall = true;
  };
  # Expect steam
  programs.steam.enable = true;
}
