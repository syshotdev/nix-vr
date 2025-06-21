{ pkgs, ... }:
{
  programs.alvr.enable = true;
  environment.systemPackages = with pkgs; [
    #unstable.steam-run
  ];
  # Expect steam
  programs.steam.enable = true;
}
