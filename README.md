# NixVR: VR Testing Ground
This repository demonstrates a NixOS config that successfully runs ALVR and SteamVR with NVidia encoding.

## Limitations
I cannot get SteamVR games running. I have never been able to do that anyways, so I can't be sure
if it's this configuration's fault or not.

### Getting started
1. Go into the `flake.nix`, and find these lines:
```nix
    computer = "desktop";
    user = "syshotdev";
```

2. Change `user` to the user you are using on NixOS.

3. Then, go to the `users` directory and rename directory `syshotdev` to the user you defined previously in the `flake.nix`

4. Then, run this command to switch your configuration.
```bash
sudo nixos-rebuild .#desktop
```

5. Your computer should now have successfully switched to the config. Restart your pc to make graphics drivers take effect.

6. Lastly, run ALVR and SteamVR.


### Details
This is running NixOS 24.05, and ALVR from NixOS 24.11.
Any NixOS version higher than 24.05 gives me the NVidia encoding error,
and any ALVR version below 24.11 is outdated.

If there are any problems getting the repository to run, please tell me.
