{
  description = "Elixir shell with custom elixir version";
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
      systems = elixir-utils.lib.defaultSystems;

      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.callPackage elixir-utils.lib.devShell {
            elixir = "1.15.3";
            erlang = "26.0.2";
          };
        };
    };
}
