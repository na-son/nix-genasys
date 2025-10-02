{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      nixos-generators,
      disko,
      ...
    }:
    {

      # images
      packages.x86_64-linux = {

        # qcow2 for kvm, nutanix
        sol = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "vm";
          modules = [
            #disko.nixosModules.disko
            ./systems/sol.nix
          ];
        };

      # vmware proprietary format
        vmware = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "vmware";
          modules = [
            disko.nixosModules.disko
            ./systems/genasys.nix
          ];
        };
      };

      # systems
      nixosConfigurations.genasys = nixpkgs.legacyPackages.x86_64-linux.nixos [
        disko.nixosModules.disko
        ./systems/genasys.nix
      ];
    };
}
