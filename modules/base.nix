{
  config,
  pkgs,
  lib,
  ...
}:
{
  hardware = {
    enableRedistributableFirmware = true;
  };

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

  time.timeZone = "UTC";

  services = {
    openssh.enable = true;
  };
  system.stateVersion = "21.11"; # don't change, keep it here

  system = {
    autoUpgrade = {
      enable = true;
      #flake = inputs.self.outPath;
      flake = "path:${config.users.users.gaia.home}/src/nix-genasys#"; # TODO: sync repos here for now
      flags = [
        "-L" # print build logs
      ];
      dates = "02:00";
      randomizedDelaySec = "45min";
    };
  };

}
