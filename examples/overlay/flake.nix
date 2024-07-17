{
  description = "Elixir overlay and shell with custom elixir version";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    elixir-utils = {
      url = "github:noaccOS/elixir-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs =
    {
      self,
      elixir-utils,
      ...
    }@inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = elixir-utils.lib.defaultSystems;
      flake.overlays.default = elixir-utils.lib.beamOverlay {
        elixir = "1.15.3";
        erlang = "26.0.2";
      };

      perSystem =
        { pkgs, system, ... }:
        {
          _module.args.pkgs = import self.inputs.nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          };

          devShells.default = pkgs.elixirDevShell;
        };
    };
}
