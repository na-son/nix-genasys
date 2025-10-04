# Images

nixos-generators provides a variety of output formats. These are specified in `packages` like below:

```nix
sol = nixos-generators.nixosGenerate {
   system = "x86_64-linux";
   format = "qcow-efi";
   modules = [
     ./systems/sol.nix
   ];
};
```

## Building

Run `nix build .#sol` . The image will end up in `./result/nixos.qcow2`

If you need to get this somewhere else, grab the path:

```shell
[gaia]🌐 genasys in nix-genasys [ main][!]
❯ cat result/nix-support/hydra-build-products
file qcow2-image /nix/store/z2njim0zrl2lzsqw5s4pdfcp2ybaj10m-nixos-disk-image/nixos.qcow2
```

on the remote system:

```shell
curl genasys/store/z2njim0zrl2lzsqw5s4pdfcp2ybaj10m-nixos-disk-image/nixos.qcow2
```

This should work for most hypervisors like nutanix or vmware with web UI using "remote image" and `http://genasys/store/...`
