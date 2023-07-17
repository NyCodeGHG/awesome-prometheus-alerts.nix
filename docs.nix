{
  pkgs,
  lib,
  runCommand,
  ...
}: 
let
  inherit (lib) removePrefix hasPrefix;
  suppressModuleArgsDocs = { lib, ... }: {
    options = {
      _module.args = lib.mkOption {
        internal = true;
      };
    };
  };
  options = (pkgs.nixosOptionsDoc {
    inherit (pkgs.lib.evalModules {
      modules = [ 
        ./nixos-module/options.nix 
        suppressModuleArgsDocs 
        {
          _module.args.pkgs = pkgs;
        }
      ];
    }) options;
    transformOptions = opt:
      opt // {
        declarations = 
          map
            (decl:
              if hasPrefix (toString ./.) (toString decl)
              then
                let subpath = removePrefix "/" (removePrefix (toString ./.) (toString decl));
                in { url = "https://github.com/NyCodeGHG/awesome-prometheus-rules.nix/blob/main"; name = subpath; }
                else decl)
                opt.declarations;
      };
  }).optionsCommonMark;
in
  runCommand "options-doc.md" {} ''
    cat ${options} >> $out
  ''
