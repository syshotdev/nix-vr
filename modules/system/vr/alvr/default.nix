{ pkgs, ... }:
{
  programs.alvr = {
    enable = true;
    package = pkgs.pkgs2411.alvr;
  };
  environment.systemPackages = with pkgs; [
    #unstable.steam-run
  ];
  # Expect steam
  programs.steam.enable = true;
}
