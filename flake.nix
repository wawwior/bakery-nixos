{
  description = "A very basic flake";

  inputs = {
    bakery.url = "github:wawwior/bakery";
  };

  outputs =
    inputs@{ ... }:
    {

    };
}
