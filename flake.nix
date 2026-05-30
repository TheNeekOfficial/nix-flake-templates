{
  description = "A flake for lagnuage templates";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {...}: {
    templates = {
      python = {
        path = ./python;
        description = "Basic template for python development w/ pandas";
      };
    };
  };
}
