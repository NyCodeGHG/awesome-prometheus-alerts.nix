{
  pkgs,
  lib,
  runCommand,
  nixosOptionsDoc,
  ...
}: let
  eval = lib.evalModules {
    modules = [
      ./nixos-module/options.nix
      {_module.args.pkgs = pkgs;}
    ];
  };
  optionsDoc = nixosOptionsDoc {
    inherit (eval) options;
    documentType = "none";
  };
in
  runCommand "options-doc.md" {} ''
    cat ${optionsDoc.optionsCommonMark} >> $out
  ''
