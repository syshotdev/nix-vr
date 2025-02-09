{ config, lib, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gtk-engine-murrine
  ];
  hardware.opengl = {
    enable = true;
    driSupport = true;
    # https://discourse.nixos.org/t/troubleshooting-steamvr/17406?u=syshotdev
    driSupport32Bit = true;
    # https://discourse.nixos.org/t/getting-an-error-has-anything-regarding-opengl-in-nixpkgs/3641/3
    setLdLibraryPath = true;
    # Mesa is general opengl drivers (I think)
    #extraPackages = [ pkgs.mesa.drivers ];
  };
}
