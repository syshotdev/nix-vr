# Every single user's base
{outputs, lib, user, pkgs,  ...}:
{
  imports = [
    (import ./home-manager-boilerplate-code.nix { inherit user pkgs outputs; } )
    outputs.homeModules.other.firefox
  ];
  # Make extra directories
  home.activation.createDirs = lib.mkAfter ''
  mkdir -p ${lib.concatMapStrings (dir: " \$HOME/${dir}") ["3d" "Programming" "Programs" "Sounds" "Temporary"]}
'';

  home.packages = with pkgs; [ 
    keepassxc # Password manager
    rhythmbox # Music player
    pinta # MS paint but linux

    fsv # File System Visualizer (For figuring out what's taking all my storage)

    yt-dlp # Youtube video downloader

    gnome.gnome-system-monitor # Task manager for linux
    lm_sensors # See temps of CPU
  ];
}
