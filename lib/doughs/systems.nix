{ ... }:
{
  output =
    {
      name,
      module,
      inputs',
    }:
    {
      nixosConfigurations.${name} = inputs'.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inputs = inputs';
        };
        modules = [ module ];
      };
    };

  attributes = {
    hostName = {
      combine = builtins.foldl' (_: str: str) "";

      resolve = {
        systems =
          { ... }:
          module: {
            networking = { inherit (module) hostName; };
          };
      };
    };
  };
}
