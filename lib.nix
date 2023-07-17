lib:
{
  asdfOverlay = import lib/asdfOverlay.nix lib;
  beamOverlay = import lib/beamOverlay.nix;
  elixirDevShell = { pkgs, withLSP ? true, erlang ? null, elixir ? null, elixir-otp ? erlang }:
    let
      beamOverlay = import lib/beamOverlay.nix { inherit erlang elixir elixir-otp; };
      finalPkgs = pkgs.extend beamOverlay;
    in
    finalPkgs.callPackage lib/elixirDevShell.nix { inherit withLSP; };
}
