{
  description = "Utilities to setup an elixir project with nix";
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      pkgsx86_66-linux = nixpkgs.legacyPackages.x86_64-linux;
    in
    {
      lib = import ./lib.nix nixpkgs.lib;
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
      formatter.x86_64-linux = pkgsx86_66-linux.nixpkgs-fmt;
      packages.x86_64-linux.updateRefs = pkgsx86_66-linux.callPackage ./util/update_sha/default.nix { };
    };
}
