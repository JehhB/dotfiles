{
  description = "Home Manager configuration of eco";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      overlays = [
        (final: prev: {
          userPackages = final.callPackage ./packages { };
        })
      ];
    in
    {
      homeConfigurations."eco" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        modules = [
          ./home.nix
        ];

      };
    };
}
