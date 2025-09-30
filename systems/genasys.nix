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
    step-ca = {
      enable = true;
      port = 8443;
      address = "0.0.0.0";
    };
    forgejo = {
      enable = true;
    };
  };

  nix.settings.allowed-users = [ "gaia" ];
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        openssh.authorizedKeys.keys = keys;
      };
      gaia = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = keys;
        extraGroups = [
          "wheel" # Enable ‘sudo’ for the user.
          "networkmanager"
          "dialout" # TTY access
        ];
      };
    };


  };

  environment.systemPackages = with pkgs; [
    inetutils
  ];
}
