{
  description = "enma's NixOS Flake";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs
	# nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      username = "ahmed";
    in {
     # Define a system called "nixos"
    nixosConfigurations."fg002" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
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
