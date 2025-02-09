{ pkgs, ... }:
{
  programs.alvr = {
    package = pkgs.alvr;
    enable = true;
    openFirewall = true;
  };
  # Expect steam
  programs.steam.enable = true;
}
