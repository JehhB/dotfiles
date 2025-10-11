{
  description = "Home Manager configuration of eco";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixvim,
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
          config.allowUnfreePredicate =
            pkg:
            builtins.elem (nixpkgs.lib.getName pkg) [
              "copilot-language-server"
            ];
        };

        modules = [
          ./home.nix
          nixvim.homeModules.nixvim
        ];
      };
    };
}
