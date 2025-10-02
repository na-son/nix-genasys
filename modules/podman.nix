{
  config,
  pkgs,
  lib,
  ...
}:
{
  # sane set of defaults for machines with podman on them
  virtualisation = {
    containers.enable = true;

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
