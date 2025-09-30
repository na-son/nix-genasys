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
    ../modules/base.nix
    ../modules/nuta.nix
    ../modules/disk.nix
  ];

  networking.hostName = "genasys";

  services = {
    forgejo = {
      enable = true;
    };
  };

  nix.settings.allowed-users = [ "gaia" ];
  users.users = {
    gaia = {
      isNormalUser = true;
      extraGroups = [
        "wheel" # Enable ‘sudo’ for the user.
        "networkmanager"
        "video" # hotplug devices and thunderbolt
        "dialout" # TTY access
        "docker"
      ];
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = keys;
    };

    root = {
      openssh.authorizedKeys.keys = keys;
    };
  };

  environment.systemPackages = with pkgs; [
    #gitAndTools.gitFull
    inetutils
    #neovim
  ];
}
