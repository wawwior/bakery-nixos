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
        modules = [
          {
            networking.hostName = module.hostName or name;
            imports = module.requires;
          }
        ];
      };
    };

  attributes = {
    hostName = {
      combine = builtins.foldl' (_: str: str) "";
    };
  };
}
