inputs@{ self, ... }:
let
  lib = self.lib // inputs.bakery.lib;
in
{

  collectFiles =
    path:
    lib.collectPaths path (
      lib.pruneFileTree (
        lib.filterFileTree (file: (builtins.match "[^\._].*\.nix" file) != null) (
          dir: (builtins.match "[^\._].*" dir) != null
        ) (lib.scanDirectory path)
      )
    );

  mkFlake = _: lib._mkFlake { inputs' = _; };

  _mkFlake =
    { inputs' }:
    expr:
    let
      importDir =
        path:
        map (
          path:
          let
            module = import path;
          in
          if builtins.isFunction module then module inputs' else module
        ) (lib.collectFiles path);

      importExpr' =
        expr':
        if builtins.isPath expr' then
          if builtins.readFileType expr' == "directory" then importDir expr' else importExpr' (import expr')
        else if builtins.isFunction expr' then
          importExpr' (expr' inputs')
        else
          [ expr' ];

      bakery = lib.enrichTypes (
        lib.parseBakery (lib.descendAttrs (importExpr' expr)).bakery
        ++ [
          {
            doughs = {
              modules = import ./doughs/modules.nix inputs;
              systems = import ./doughs/systems.nix inputs;
            };
          }
        ]
      );

      outputs = lib.produceOutputs bakery inputs';

    in
    outputs
    // {
      inherit bakery;
    };

}
