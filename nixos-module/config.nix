{
  pkgs,
  lib,
  config,
  ...
}:
# please don't look at this
let
  inherit (import ./lib.nix {inherit pkgs lib;}) makeName mapServices getPackageFiles;
  files = lib.flatten (lib.attrValues (mapServices ({
    name,
    package,
  }: (lib.attrValues (lib.filterAttrs (name: value: let
    fancyName = makeName name;
  in
    config.services.prometheus.awesome-prometheus-alerts.${package.name}.${fancyName}.enable) (
    lib.mapAttrs (name: value: "${package}/${name}") (getPackageFiles package)
  ))))));
in {
  config.services.prometheus.ruleFiles = files;
}
