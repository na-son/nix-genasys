{
  config,
  pkgs,
  lib,
  ...
}:
{
  # this is a sane set of defaults for automaic HTTP-01 validation
  # https://nixos.org/manual/nixos/stable/#module-security-acme-configuring


  security.acme.acceptTerms = true;
  #security.acme.defaults.email = "mail@example.com";

  users.users.nginx.extraGroups = [ "acme" ];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "acmechallenge.example.com" = {
        # wildcard so we can use any valid hostname
        serverAliases = [ "*.example.com" ];
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
}
