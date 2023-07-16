{
  pkgs,
  lib,
}: let
  mappings = {
    "embedded-exporter-v1.yml" = "v1";
    "embedded-exporter-v2.yml" = "v2";
    "prometheus-self-monitoring.yml" = "prometheus";
  };
  removeSuffixes = suffixes: value: let
    len = builtins.length suffixes;
  in
    if (len == 0)
    then value
    else removeSuffixes (lib.take (len - 1) suffixes) (lib.removeSuffix (lib.last suffixes) value);
in rec {
  packages = pkgs.awesome-prometheus-alerts;
  makeName = name:
    mappings.${name} or (removeSuffixes [".yaml" ".yml"] name);
  mapServices = lambda: builtins.mapAttrs (name: package: (lambda {inherit name package;})) packages;
  getPackageFiles = package: lib.filterAttrs (name: value: value == "regular" && (lib.hasSuffix ".yml" name || lib.hasSuffix ".yaml" name)) (builtins.readDir "${package}");
}
