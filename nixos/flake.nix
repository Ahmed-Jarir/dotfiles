{
  description = "enma's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let

      inherit (self) outputs;
      system = "x86_64-linux";

    in {
    nixosConfigurations."nixos" = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        username = "ahmed";
      };
      modules = [
        
        ./system/configuration.nix
      ];
    };
    homeConfigurations."ahmed@nixos" = 
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs;};
        modules = [./home/home.nix];
    };
  };
}
