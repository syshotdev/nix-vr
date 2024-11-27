# Every single user's base
{outputs, lib, user, pkgs,  ...}:
{
  imports = [
    (import ./home-manager-boilerplate-code.nix { inherit user pkgs outputs; } )
    outputs.homeModules.other.firefox
  ];
  # Make extra directories
  home.activation.createDirs = pkgs.lib.mkAfter ''
  mkdir -p ${lib.concatMapStrings (dir: " \$HOME/${dir}") ["3d" "Programming" "Programs" "Sounds" "Temporary"]}
'';

  home.packages = with pkgs; [ 
    gnome.gnome-system-monitor
  ];

  # ---------- home-manager boilerplate starts HERE ----------
  # Enable home-manager and git (Essential)
  programs.home-manager.enable = true;
  programs.git.enable = true;


  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
