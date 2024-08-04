{
  description = "Dell XPS flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    my-home.url = "github:atcol/config-files?ref=master";
  };

  outputs = { self, nixpkgs, home-manager, my-home } @ inputs: 
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in {

    nixosConfigurations.aelfred = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.atc = (my-home.nixosModules."${system}".default {  }).config;
        }
      ];
    };

  };
}
