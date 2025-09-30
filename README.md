# Nix Gen-A-Sys

This repo contains both nixosConfigurations, and nixos-generator configurations for nixos machines.

## install

The size of the tmp nix store must be increased:

```shell
mount -o remount,size=15G /nix/.rw-store
```

Format, partition, and install nixos.

```shell
sudo nix --extra-experimental-features 'nix-command flakes' run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake 'github:na-son/nix-genasys#genasys' --disk sda /dev/sda
```

## updates

To update a given system,

```shell
nixos-rebuild switch --flake .#
```

## misc

[nh](https://github.com/nix-community/nh) is available:


## image generation

[nixos-generators](https://github.com/nix-community/nixos-generators) is included.

## plans

[attic](https://github.com/zhaofengli/attic) for binary cache
[acme](https://nixos.org/manual/nixos/stable/#module-security-acme)


