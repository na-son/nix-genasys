{
  config,
  pkgs,
  lib,
  ...
}:
# this is a sane set of defaults for automatic HTTP-01 validation
# https://nixos.org/manual/nixos/stable/#module-security-acme-configuring

let
  cfg = config.services.acme-http;
in
{
  options.services.acme-http = {
    enable = lib.mkEnableOption "ACME HTTP-01 with NGINX";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "example.com";
    };
    mail = lib.mkOption {
      type = lib.types.str;
      default = "mail@example.com";
    };
  };

  config = lib.mkIf cfg.enable {
    security.acme.acceptTerms = true;
    security.acme.defaults.email = cfg.mail;

    users.users.nginx.extraGroups = [ "acme" ];

    services.nginx = {
      enable = true;
      virtualHosts = {
        "acmechallenge.${cfg.domain}" = {
          # wildcard so we can use any valid hostname
          serverAliases = [ "*.${cfg.domain}" ];
          locations."/.well-known/acme-challenge" = {
            root = "/var/lib/acme/.challenges";
          };
          # HTTPS Redirect
          locations."/" = {
            return = "301 https://$host$request_uri";
          };
        };
      };
    };
  };
}
