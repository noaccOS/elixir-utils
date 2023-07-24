{
  description = "Simple elixir project with default elixir versions";
  inputs.nixpkgs.url = "nixpkgs/nixpkgs-unstable";
  inputs.elixir-utils = {
    url = "github:noaccOS/elixir-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, elixir-utils }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      devShell.default = elixir-utils.lib.elixirDevShell { inherit pkgs; };
    };
}
