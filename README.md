# awesome-prometheus-rules.nix

Nix packages and NixOS module for [awesome-prometheus-alerts](https://github.com/samber/awesome-prometheus-alerts).

## Usage

### With Flakes

Add this flake as an input:

```nix
{
  inputs = {
    # ...
    awesome-prometheus-rules = {
      url = "github:NyCodeGHG/awesome-prometheus-rules.nix";
      # This is optional, but recommended. It reduces the amount of dependencies and clutter in your flake.lock
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, awesome-prometheus-rules, ... }: {
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        awesome-prometheus-rules.nixosModules.default
        {
          services.prometheus = {
            enable = true;
            awesome-prometheus-alerts = {
              prometheus-self-monitoring.embedded-exporter.enable = true;
            };
          };
        }
      ];
    };
  }
}
```

### Without Flakes

This is currently not supported. Feel free to make a PR :)

## License

Licensed under the MIT license ([LICENSE](LICENSE) or http://opensource.org/licenses/MIT)
