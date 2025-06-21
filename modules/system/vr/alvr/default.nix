{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    unstable.alvr
    unstable.steam-run
  ];
  # Expect steam
  programs.steam.enable = true;
}
