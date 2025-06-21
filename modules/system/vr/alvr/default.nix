{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.alvr
  ];
  # Expect steam
  programs.steam.enable = true;
}
