{
  description = "Elixir shell with custom elixir version";
  inputs = {
    nixpkgs.url = nixpkgs/nixpkgs-unstable;
    elixir-utils = { url = github:noaccOS/elixir-utils; inputs.nixpkgs.follows = "nixpkgs"; };
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, elixir-utils, flake-utils }:
    let systems = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "i686-linux" ];
    in flake-utils.eachSystem systems (system:
      let pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.${system}.default ]; };
      in {
        overlays.default = elixir-utils.lib.beamOverlay { elixir = "1.15.3"; erlang = "26.0.2"; };
        devShell.default = elixir-utils.lib.elixirDevShell { inherit pkgs; };
      });
}
