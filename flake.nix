{
  description = "A very basic flake";

  inputs = {
    bakery.url = "github:wawwior/bakery";
  };

  outputs =
    inputs@{ ... }:
    {
      bakery.doughs = {
        modules = import ./doughs/modules.nix inputs;
        systems = import ./doughs/systems.nix inputs;
      };
    };
}
