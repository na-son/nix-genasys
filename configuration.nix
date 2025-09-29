{
  config,
  pkgs,
  user,
  lib,
  ...
}:

let
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKoLhJuOE878n9BaTFAAmGgmGjztT61HsMRJOU+uKf/t+pJLxUOn3Or2CLMG5EkfKiTZzLFRQ9y1IvHPvmrM5QB5obJP6mJm2xNlL6wmDBKF0qpcXCU5nX3SmFJdbLg5a4FRWLSdMifWK75kvOSBskTYv81W5ncsbRdHK67AciarHYbkPoktoJpJE4EpEPMrPGLS7AaRo1zfbrIfOJJc4LzX2jBzNg1gw0/iPX39KPB/F+N6DzEh8cd43B3dKlqHscHCerpsHVF0EIgFkGm76MrgoJO92qAjeln9ibVSjU9ysS0YP7Z5khyyd19HQFiMQ6Dvp5cmUxndgvKdHooGE/"
  ];
in
{
  imports = [
    ./disk-config.nix
  ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 42;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = [
      "ata_piix"
      "virtio_pci"
      "virtio_scsi"
      "uhci_hcd"
      "sd_mod"
      "sr_mod"
    ];

    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [
      "tun"
    ];
  };

  #time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "genasys";
    usePredictableInterfaceNames = lib.mkDefault true;
    networkmanager.enable = true;
    useDHCP = false;
  };

  nix = {
    #nixPath = [ "nixos-config=/home/${user.name}/.local/share/src/nixos-config:/etc/nixos" ];
    package = pkgs.nixVersions.latest;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      #allowed-users = [ "${user.name}" ];
      auto-optimise-store = true;
    };
  };
  
  programs = {
    dconf.enable = true;
    zsh.enable = true;
  };

  services = {
    dbus.enable = true;
    openssh.enable = true;
  };

  #systemd = {
  #  services = {
  #    };
  #  };
  #};

  hardware = {
    enableRedistributableFirmware = true;
  };

  #virtualisation = {
  #  containers.enable = true;

  #  podman = {
  #    enable = true;
  #    dockerCompat = true;
  #    defaultNetwork.settings.dns_enabled = true;
  #  };
  #};

  users.users = {
    #${user.name} = {
    #  isNormalUser = true;
    #  extraGroups = [
    #    "wheel" # Enable ‘sudo’ for the user.
    #    "networkmanager"
    #    "video" # hotplug devices and thunderbolt
    #    "dialout" # TTY access
    #    "docker"
    #  ];
    #  shell = pkgs.zsh;
    #  openssh.authorizedKeys.keys = keys;
    #};

    root = {
      openssh.authorizedKeys.keys = keys;
    };
  };

  security.sudo = {
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

  environment.systemPackages = with pkgs; [
    gitAndTools.gitFull
    inetutils
  ];

  system.stateVersion = "21.11"; # Don't change this
}
