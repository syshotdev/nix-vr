{ user, ...}:
{
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
