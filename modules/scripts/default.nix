{ pkgs, config, ... }:
let
  # Helper function for making commands that you can execute via terminal
  mkScript = name: scriptPath:
    (pkgs.writeScriptBin name (builtins.readFile scriptPath));
in {
  environment.systemPackages = with pkgs; [
    ripgrep
    # A script for rebuilding my system (based on this config)
    (mkScript "rebuild" ./RebuildSystem.sh)
  ];
}
