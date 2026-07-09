{
  description = "auhhhhhhhhhhhhhhhhhhhhhg";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, disko, zen-browser, ... }@inputs:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs zen-browser; };
        modules = [
          disko.nixosModules.disko
          ./hosts/laptop/disko.nix
          ./hosts/laptop/hardware-configuration.nix
          ./hosts/laptop/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs zen-browser; };
            home-manager.users.tard = import ./home/home.nix;
          }
        ];
      };
    };
}
