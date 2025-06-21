{ pkgs, ... }:
{
  programs.alvr = {
    enable = true;
    package = pkgs.unstable.alvr;
  };
  environment.systemPackages = with pkgs; [
    #unstable.steam-run
  ];
  # Expect steam
  programs.steam.enable = true;
}
