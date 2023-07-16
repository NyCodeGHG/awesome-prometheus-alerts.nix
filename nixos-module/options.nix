{
  pkgs,
  lib,
  ...
}: let
  inherit (import ./lib.nix {inherit pkgs lib;}) makeName mapServices getPackageFiles;
  mkOption = with lib;
    {
      name,
      package,
    }: {
      options = mapAttrs' (name: value: let
        fancyName = makeName name;
      in
        nameValuePair fancyName {
          enable = lib.mkOption {
            type = types.bool;
            default = false;
            description = ''
              Enables the ${fancyName} Prometheus rules.
            '';
          };
        })
      (getPackageFiles package);
    };
  services = mapServices mkOption;
  options = lib.mapAttrs (_: value: value.options) services;
in {
  options.services.prometheus.awesome-prometheus-alerts = options;
}
