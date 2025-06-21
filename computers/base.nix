# This configuration file is shared by ALL of the computers, 
# to quickly set up essential services.
# Credits: my original config (made by the nixos installer), github user MattCairns with his
# nixos config, vimjoyer's videos, and a couple other people who are on GitHub. Thank you guys
{
  inputs,
  outputs,
  computer,
  config,
  lib,
  pkgs,
  ...
}: {
  # Bootloader stuff, like grub and if the system can boot
  boot.loader = {
    timeout = 120; # Seconds till grub chooses option to boot
    efi.canTouchEfiVariables = true;
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev"; # Let the bootloader decide where to put grub (not manual)
  };

  # Hostname on network
  networking.hostName = "${computer}";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true; 
  };

  # Disable IPv6
  networking.enableIPv6 = false;
  boot.kernelParams = ["ipv6.disable=1"]; # Firefox takes a long time to load and apparently this helps

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION= "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # I don't know what this code does. Let's call it "magic" and not touch it for now
  # Extra nix options, like enabling flakes.
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      # Opinionated: disable global registry
      flake-registry = "";
      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;
    };
    # Opinionated: disable channels
    channel.enable = false;

    # Opinionated: make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Enable X11 and Cinnamon (For showing the desktop)
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = true;
    desktopManager.cinnamon.enable = true;

    # Settings for desktop, like theme and keybinds
    desktopManager.cinnamon = {
      extraGSettingsOverridePackages = with pkgs; [];
      extraGSettingsOverrides = '' '';
    };

    xkb.layout = "us"; # Probably keyboard layout
    xkb.variant = ""; # No idea what this means
  };

  # Sound stuff
  sound.enable = true;
  security.rtkit.enable = true; # This to make less audio stuttering
  hardware.pulseaudio.enable = false;
  services.pipewire = { 
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Fonts because Chinese / Unicode characters don't show up correctly
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-extra
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  # https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
  # Add unstable packages
  nixpkgs.overlays = [
    (final: _: {
      pkgs2411 = import inputs.nixpkgs-24_11 { inherit (final.stdenv.hostPlatform) system; inherit (final) config; };
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];
  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary packages
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = (_: true);
  };

  system.stateVersion = "24.05"; # Version of system
}
