# awesome-prometheus-rules.nix

[https://github.com/samber/awesome-prometheus-alerts](awesome-prometheus-alerts) packages using [nix](https://nixos.org).


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
        {
          services.prometheus = {
            enable = true;
            prometheus-self-monitoring.embedded-exporter.enable = true;
          };
        }
      ];
    };
  }
}
```