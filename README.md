# Nix Gen-A-Sys

This repo contains both nixosConfigurations, and nixos-generator configurations for nixos machines.

## install

The size of the tmp nix store must be increased:

```shell
mount -o remount,size=15G /nix/.rw-store
```

Format, partition, and install nixos.

```shell
sudo nix --extra-experimental-features 'nix-command flakes' run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake '/tmp/config/etc/nixos#genasys' --disk sda /dev/sda
```

