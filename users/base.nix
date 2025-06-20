# Every single user's base
{ inputs, outputs, lib, user, pkgs,  ...}:
{
  imports = [
    outputs.modulesHome.other.firefox
  ];
  # Make extra directories
  home.activation.createDirs = pkgs.lib.mkAfter ''
  mkdir -p ${lib.concatMapStrings (dir: " \$HOME/${dir}") ["3d" "Programming" "Programs" "Sounds" "Temporary"]}
'';

  # Default packages, to prevent softlocks
  home.packages = with pkgs; [ 
    git
    #firefox
    rhythmbox
    wget
    ripgrep
    openssl
    gnome-system-monitor
  ];

  # ---------- home-manager boilerplate starts HERE ----------
  # Enable home-manager and git (Essential)
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # https://discourse.nixos.org/t/mixing-stable-and-unstable-packages-on-flake-based-nixos-system/50351/4
  # Add unstable packages
  nixpkgs.overlays = [
    (final: _: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];
  nixpkgs.config = {
    allowUnfree = true; # Allow proprietary packages
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    allowUnfreePredicate = (_: true); # Ima be honest Idk if it was an issue in the first place
  };

  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
