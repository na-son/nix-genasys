


# install

mount -o remount,size=15G /nix/.rw-store

sudo nix --extra-experimental-features 'nix-command flakes' run 'github:nix-community/disko/latest#disko-install' -- --write-efi-boot-entries --flake '/tmp/config/etc/nixos#genasys' --disk sda /dev/sda
