{
  pkgs,
  awesome-prometheus-alerts,
}: let
  dirs = pkgs.lib.filterAttrs (name: value: value == "directory") (builtins.readDir "${awesome-prometheus-alerts}/dist/rules");
  singlePackage = {
    name,
    stdenvNoCC,
    awesome-prometheus-alerts,
  }:
    stdenvNoCC.mkDerivation {
      inherit name;
      src = "${awesome-prometheus-alerts}/dist/rules";

      buildPhase = ''
        mkdir -p $out
        cp $src/${name}/*.{yaml,yml} $out || cp $src/${name}/**/*.{yaml,yml} $out
      '';

      phases = ["buildPhase"];

      meta = with pkgs.lib; {
        description = "Prometheus rules for ${name}.";
        homepage = "https://samber.github.io/awesome-prometheus-alerts/";
        license = licenses.cc-by-40;
        platforms = platforms.all;
      };
    };
  package = builtins.mapAttrs (name: value: pkgs.callPackage singlePackage {inherit awesome-prometheus-alerts name;}) dirs;
in
  package
