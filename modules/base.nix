{
  config,
  pkgs,
  lib,
  ...
}:
# base system configuration, suitable for most full-featured systems
{
  environment.loginShellInit = ''
        if [ `id -u` != 0 ]; then
          if [ "x''${SSH_TTY}" != "x" ]; then
            ${pkgs.macchina}/bin/macchina -i ens3 \
    	-o host \
    	-o local-ip \
    	-o packages \
    	-o distribution \
    	-o uptime \
    	-o processor-load \
    	-o memory \
    	-o disk-space 
    	
          fi 
        fi
  '';

  hardware.enableRedistributableFirmware = true;

  networking = {
    networkmanager.enable = lib.mkDefault true;
    usePredictableInterfaceNames = lib.mkDefault true;
    useDHCP = false;
  };

  nix = {
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      auto-optimise-store = true;
    };
  };

  programs = {
    git.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/gaia/src/nix-genasys"; # sets NH_OS_FLAKE variable for you
    };

    starship = {
      enable = true;
      presets = [ "bracketed-segments" ];
    };

    zsh = {
      enable = true;
    };
  };

  security.sudo-rs = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/reboot";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  services = {
    openssh.enable = true;
  };

  system = {
    autoUpgrade = {
      enable = true;
      #flake = inputs.self.outPath;
      flake = "path:${config.users.users.gaia.home}/src/nix-genasys#";
      flags = [
        "-L" # print build logs
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
    stateVersion = "21.11";
    userActivationScripts.zshrc = "touch .zshrc";
  };

  time.timeZone = "UTC";
}
