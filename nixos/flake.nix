{
  description = "enma's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gc-env.url = "github:Julow/nix-gc-env";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let

      inherit (self) outputs;
      system = "x86_64-linux";

      # lib = nixpkgs.lib;

    in {
    nixosConfigurations."nixos" = inputs.nixpkgs.lib.nixosSystem {
      inherit system;

      specialArgs = {
        username = "ahmed";
      };
      modules = [
        
        # ytmp.overlays.${system}.default]; 
        ./configuration.nix
      ];
    };
    homeConfigurations."ahmed@nixos" = 
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = {inherit inputs;};
        modules = [./home.nix];
    };
      #   home-manager.nixosModules.home-manager
      #   ({ pkgs, nixvim, config, ... }: {
      #     home-manager = {
      #     	useGlobalPkgs = true;
      #     	useUserPackages = true;
      #     	users = {
      #     		ahmed = import ./user.nix; 
      #     	};
      #     };
      #   })
      # ];
  };
}
