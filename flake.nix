{
  description = "awesome-prometheus-alerts";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    awesome-prometheus-alerts = {
      url = "github:samber/awesome-prometheus-alerts";
      flake = false;
    };
  };
  outputs = {
    self,
    nixpkgs,
    awesome-prometheus-alerts,
  } @ inputs: let
    pkgs = system:
      import nixpkgs {
        inherit system;
        overlays = [self.overlays.default];
      };
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ] (system: function (pkgs system));
    packages = pkgs:
      import ./package.nix {
        inherit awesome-prometheus-alerts pkgs;
      };
    docs = pkgs: {docs = pkgs.callPackage ./docs.nix {inherit inputs;};};
  in {
    packages = forAllSystems (pkgs: (packages pkgs) // (docs pkgs));
    overlays.default = final: prev: {awesome-prometheus-alerts = packages nixpkgs.legacyPackages.${prev.system};};
    nixosModules.default = {
      imports = [
        ./nixos-module/options.nix
        ./nixos-module/config.nix
        {
          nixpkgs.overlays = [self.overlays.default];
        }
      ];
    };
    nixosConfigurations = forAllSystems (pkgs: {
      example = nixpkgs.lib.nixosSystem {
        system = pkgs.system;
        modules = [
          self.nixosModules.default
          ./example.nix
        ];
      };
    });
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        buildInputs = with pkgs; [ mdbook ];
      };
    });
  };
}
