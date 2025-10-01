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

To update a given system, simply run `nh os switch`. Alternatively:

```shell
cd /home/gaia/src
git clone https://github.com/na-son/nix-genasys.git
cd nix-genasys
nh os switch .#
```

## misc

ca bootstrap:

```shell
# copy the root over
scp root.crt gaia@genasys:
step certificate create "genasys" intermediate.csr intermediate.key --csr

# windows 
certreq -submit -attrib "CertificateTemplate:SubCA" intermediate.csr intermediate.crt

scp intermediate.crt gaia@genasys:
mv intermediate.crt /etc/ssl/certs/intermediate.crt
mv intermediate.key /etc/ssl/certs/intermediate.key
mv root.crt /etc/ssl/certs/root.crt
# put the key in /run/keys/intermediate.password
sudo chown step-ca:nobody /etc/ssl/certs/intermediate.crt
sudo chown step-ca:nobody /etc/ssl/certs/intermediate.key
sudo chown step-ca:nobody /etc/ssl/certs/root.pem
sudo chown step-ca:nobody /run/keys/intermediate.key
```
[nh](https://github.com/nix-community/nh) is available

## image generation

[nixos-generators](https://github.com/nix-community/nixos-generators) is included.

## plans

[attic](https://github.com/zhaofengli/attic) for binary cache
[acme](https://nixos.org/manual/nixos/stable/#module-security-acme)


