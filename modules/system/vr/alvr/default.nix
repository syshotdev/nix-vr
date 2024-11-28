{ pkgs, ... }:
{
  programs.alvr = {
    enable = true;
    openFirewall = true;
  };
  # Expect steam
  programs.steam.enable = true;
}
