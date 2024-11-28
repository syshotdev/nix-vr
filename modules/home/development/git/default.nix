{user, nickname, email, lib, ...}: 
let
  enable-ssh = builtins.pathExists /home/${user}/.ssh/id_ed25519.pub;
in {
  programs.git = {
    enable = true;
    userName = "${nickname}";
    userEmail = "${email}";

    # If ssh key exists, put this config. Otherwise, go with simpler config
    extraConfig = {
      init = {defaultBranch = "main";};
      pull = {rebase = true;};
      rebase = {
        autostash = true;
        autosquash = true;
      };
      rerere = {enabled = true;};
      push = {autoSetupRemote = true;};

      core = {
        whitespace = "trailing-space,space-before-tab";
        editor = "vim";
      };
      # If enable-ssh, then add these attibutes
    } // lib.optionalAttrs enable-ssh {
      commit = {gpgsign = true;};
      gpg = {format = "ssh";};
      user = {signingkey = "/home/${user}/.ssh/id_ed25519.pub";};
    };
  };
}
