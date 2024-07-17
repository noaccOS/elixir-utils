{
  description = "Utilities to setup an elixir project with nix";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.flake-parts.url = "github:hercules-ci/flake-parts";
  inputs.flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  inputs.systems.url = "github:nix-systems/default";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.self.lib.defaultSystems;
      flake.lib =
        let
          allSystems = inputs.nixpkgs.lib.platforms.unix;
          defaultGlobalSystems = import inputs.systems;
          defaultSystems = inputs.nixpkgs.lib.lists.intersectLists allSystems defaultGlobalSystems;
        in
        import ./lib.nix inputs.nixpkgs.lib allSystems defaultSystems;

      flake.templates = {
        default = inputs.self.templates.simple;
        simple = {
          path = examples/simple;
          description = "Simple elixir shell with default elixir version";
        };
        custom = {
          path = examples/custom;
          description = "Elixir shell with custom elixir version";
        };
        asdf = {
          path = examples/asdf;
          description = "Elixir shell with elixir version from .tool-versions";
        };
        overlay = {
          path = examples/overlay;
          description = "Elixir overlay and shell with custom elixir version";
        };
      };

      flake.overlays.default = {

      };

      perSystem =
        { self', pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;
          packages.updateRefs = pkgs.callPackage ./util/update_sha/default.nix { };
          devShells.default = pkgs.callPackage inputs.self.lib.devShell { };
          devShells.latest = pkgs.callPackage inputs.self.lib.devShell {
            erlang = "27";
            elixir = "1.16";
          };
        };
    };
}
