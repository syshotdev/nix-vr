{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alvr
  ];
  # Expect steam
  programs.steam.enable = true;
}
