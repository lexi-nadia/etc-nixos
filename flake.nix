{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      lix-module,
      nixos-hardware,
      home-manager,
    }:
    {
      nixosConfigurations = {
        octavia = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            lix-module.nixosModules.default
            nixos-hardware.nixosModules.framework-13th-gen-intel
            home-manager.nixosModules.home-manager
            ./hosts/octavia.nix
            ./configuration.nix
          ];
        };
        umi = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            lix-module.nixosModules.default
            home-manager.nixosModules.home-manager
            ./hosts/umi.nix
            ./configuration.nix
          ];
        };
      };
    };
}
