# Installation

<!-- toc -->

## With Flakes

Add the project as an input to your flake.

```nix
{
  inputs = {
    # ...
    awesome-prometheus-alerts = {
      url = "github:NyCodeGHG/awesome-prometheus-alerts.nix";
      # This is optional, but recommended. It reduces the amount of dependencies and clutter in your flake.lock
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

Now you can add the module to your NixOS configuration.

```nix
{
  outputs = { nixpkgs, awesome-prometheus-alerts, ... }: {
    # ...
    nixosConfigurations.example = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        awesome-prometheus-alerts.nixosModules.default
      ];
    };
  }
}
```

With that module enabled, you can just enable the prometheus rules you want, you can find a list of all module options [here](../options.md) and a list of all available rules on the [upstream projects documentation](https://samber.github.io/awesome-prometheus-alerts/).

```nix
{
  services.prometheus = {
    enable = true;
    awesome-prometheus-alerts = {
      # Enable Prometheus Self monitoring
      prometheus-self-monitoring.embedded-exporter.enable = true;
      # Enable Node Exporter alerts
      host-and-hardware.node-exporter.enable = true;
    };
  };
}
```

## Without Flakes

This project currently only works with Flakes, but feel free to contribute an integration with [flake-compat](https://github.com/edolstra/flake-compat). :)
