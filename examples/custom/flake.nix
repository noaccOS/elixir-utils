{
  description = "Elixir shell with custom elixir version";
  inputs = {
    nixpkgs.url = nixpkgs/nixpkgs-unstable;
    elixir-utils = { url = github:noaccOS/elixir-utils; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, elixir-utils, flake-utils }:
    flake-utils.eachSystem elixir-utils.lib.defaultSystems (system:
      let pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.${system}.default ]; };
      in {
        overlays.default = elixir-utils.lib.beamOverlay { elixir = "1.15.3"; erlang = "26.0.2"; };
        devShell.default = final.elixirDevShell;
      });
}
