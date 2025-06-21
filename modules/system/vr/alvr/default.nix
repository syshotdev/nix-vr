{ pkgs, ... }:
{
  programs.alvr = {
    enable = true;
    package = pkgs.pkgs2411.alvr;
  };
}
