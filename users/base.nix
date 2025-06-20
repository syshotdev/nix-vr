# Every single user's base
{ inputs, outputs, lib, user, pkgs,  ...}:
{
  # TODO: Decide if packages need to be in here-- or if I can remove this entirely.
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
  home.stateVersion = "25.05";
}
