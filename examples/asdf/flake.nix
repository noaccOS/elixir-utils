{
  description = "Elixir shell from .tool-versions";
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    elixir-utils = { url = github:noaccOS/elixir-utils; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, elixir-utils, flake-utils }:
    flake-utils.eachSystem elixir-utils.lib.defaultSystems (system:
      let pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.${system}.default ]; };
      in {
        overlays.default = elixir-utils.lib.asdfOverlay { src = ./.; };
        devShells.default = elixir-utils.lib.elixirDevShell { inherit pkgs; };
      });
}
