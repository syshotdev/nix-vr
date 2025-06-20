{ config, lib, pkgs, ... }:
{
  hardware.graphics = {
    enable = true;
    # Mesa is general opengl drivers (I think)
    extraPackages = [ pkgs.mesa ];
  };
}
