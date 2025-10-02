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
      packages.x86_64-linux = {
        sol = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          format = "vm";
          modules = [
            ./systems/sol.nix
          ];
        };

        # systems
        nixosConfigurations.genasys = nixpkgs.legacyPackages.x86_64-linux.nixos [
          disko.nixosModules.disko
          ./systems/genasys.nix
        ];

        nixosConfigurations.sol = nixpkgs.legacyPackages.x86_64-linux.nixos [
          #disko.nixosModules.disko
          ./systems/sol.nix
        ];
      };
    };
}
