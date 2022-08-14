{
  description = "enma's NixOS Flake";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
	# nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    ytmpPkg.url = "github:Ahmed-Jarir/yt-mp";
    nur.url = "github:nix-community/NUR";
  };

  outputs = { nixpkgs, home-manager, ytmpPkg, nur, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      ytmp = ytmpPkg.defaultPackage.${system};
      lib =  nixpkgs.lib;
    in {
     # Define a system called "nixos"
    nixosConfigurations."fg002" = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        #{
        #  nur-no-pkgs = import nur {
        #    nurpkgs = import nixpkgs { system = "x86_64-linux"; };
        #    repoOverrides = { ytmp = import ytmp { }; };
        #  };
        #}
        
        { nixpkgs.overlays = [ nur.overlay ]; }
        ./configuration.nix
        #{
        #  inherit ytmp;
        #}
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

		# home-manager.lib.homeManagerConfiguration {
	    #       # Specify the path to your home configuration here
	    #       configuration = import ./home.nix;
	  
	    #       inherit system username;
	    #       homeDirectory = "/home/${username}";
	    #       # Update the state version as needed.
	    #       # See the changelog here:
	    #       # https://nix-community.github.io/home-manager/release-notes.html#sec-release-21.05
	    #       stateVersion = "21.11";
	    #       # Optionally use extraSpecialArgs
	    #       # to pass through arguments to home.nix
	 
	    #   }
      ];
    };

};
}
