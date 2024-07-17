{
  description = "Elixir shell with elixir version from .tool-versions";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    elixir-utils = {
      url = "github:noaccOS/elixir-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    { elixir-utils, ... }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      system = elixir-utils.lib.defaultSystems;
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.callPackage elixir-utils.lib.asdfDevShell { src = ./.; };
        };
    };
}
