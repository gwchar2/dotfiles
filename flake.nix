{
  description = "Small reproducible macOS and NixOS dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      ...
    }:
    let
      username = "gwchar2";
      darwinSystem = "aarch64-darwin";
      linuxSystem = "x86_64-linux";
      specialArgs = { inherit self username; };
    in
    {
      darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
        system = darwinSystem;
        inherit specialArgs;
        modules = [
          ./configuration.nix
          nix-homebrew.darwinModules.nix-homebrew
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = specialArgs;
            home-manager.users.${username} = import ./home.nix;
          }
        ];
      };

      homeConfigurations."${username}@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${linuxSystem};
        extraSpecialArgs = specialArgs;
        modules = [ ./home.nix ];
      };

      nixosModules.default = import ./nixos.nix;
    };
}
