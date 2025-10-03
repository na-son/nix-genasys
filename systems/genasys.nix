{
  config,
  pkgs,
  user,
  lib,
  ...
}:
# genasys is used to genesis ur nix boxes
let
  keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKoLhJuOE878n9BaTFAAmGgmGjztT61HsMRJOU+uKf/t+pJLxUOn3Or2CLMG5EkfKiTZzLFRQ9y1IvHPvmrM5QB5obJP6mJm2xNlL6wmDBKF0qpcXCU5nX3SmFJdbLg5a4FRWLSdMifWK75kvOSBskTYv81W5ncsbRdHK67AciarHYbkPoktoJpJE4EpEPMrPGLS7AaRo1zfbrIfOJJc4LzX2jBzNg1gw0/iPX39KPB/F+N6DzEh8cd43B3dKlqHscHCerpsHVF0EIgFkGm76MrgoJO92qAjeln9ibVSjU9ysS0YP7Z5khyyd19HQFiMQ6Dvp5cmUxndgvKdHooGE/"
  ];
in
{
  imports = [
    ../modules/base.nix
    ../modules/nuta.nix
    ../modules/disk/standard.nix
  ];

  networking.hostName = "genasys";

  services = {
    step-ca = {
      enable = true;
      address = "0.0.0.0";
      port = 8443;
      openFirewall = true;
      intermediatePasswordFile = "/run/keys/intermediate.password";
      settings = {
        root = "/etc/ssl/certs/root.crt";
        crt = "/etc/ssl/certs/intermediate.crt";
        key = "/etc/ssl/certs/intermediate.key";
        dnsNames = [
          "genasys.schrodinger.com"
        ];
        logger = {
          format = "text";
        };
        db = {
          type = "badgerv2";
          dataSource = "/var/lib/step-ca/db";
          badgerFileLoadingMode = "";
        };
        authority = {
          provisioners = [
            {
              name = "acme";
              type = "ACME";
            }
          ];
        };
        tls = {
          cipherSuites = [
            "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
            "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
          ];
          minVersion = 1.2;
          maxVersion = 1.3;
          renegotiation = false;
        };

      };
    };
  };

  nix.settings.allowed-users = [
    "@wheel"
  ];
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
    openssl
    step-cli
  ];
}
