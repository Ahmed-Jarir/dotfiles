{
  description = "enma's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    # ytmp.url = "github:Ahmed-Jarir/yt-mp";
  };

  outputs = { nixpkgs, home-manager, ... }: #, ytmp
    let

      system = "x86_64-linux";

      lib = nixpkgs.lib;

    in {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        
        # { nixpkgs.overlays = [ 
        #     ytmp.overlays.${system}.default
        #   ];
        # }
        # ytmp.overlays.${system}.default]; 
        ./configuration.nix

    home-manager.nixosModules.home-manager
        ({ pkgs, config, ... }: {
          home-manager = {
          	useGlobalPkgs = true;
          	useUserPackages = true;
          	users = {
          		ahmed = import ./user.nix; 
          	};
          };
        })
      ];
    };
  };
}
