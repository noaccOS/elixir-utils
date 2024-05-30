{
  description = "Utilities to setup an elixir project with nix";
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
  let
    allSystems = nixpkgs.lib.platforms.unix;
    defaultSystems = nixpkgs.lib.lists.intersectLists allSystems flake-utils.lib.defaultSystems;
  in
  (
    {
      lib = import ./lib.nix nixpkgs.lib allSystems defaultSystems;
      templates = {
        default = self.templates.simple;
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
      };
    } //
      flake-utils.lib.eachSystem defaultSystems (system:
        let pkgs = import nixpkgs { inherit system; }; in
        {
          formatter = pkgs.nixpkgs-fmt;
          packages.updateRefs = pkgs.callPackage ./util/update_sha/default.nix { };
          devShells.default = self.lib.devShell { inherit pkgs; };
          devShells.latest = self.lib.devShell { inherit pkgs; erlang = "27"; elixir = "1.16"; };
        })
    );
}
