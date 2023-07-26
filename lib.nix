lib:
rec {
  defaultSystems = lib.platforms.unix;
  asdfOverlay = import lib/asdfOverlay.nix lib;
  beamOverlay = import lib/beamOverlay.nix;
  elixirDevShell = { pkgs, withLSP ? true, erlang ? null, elixir ? null, elixir-otp ? erlang }:
    let
      overlay = beamOverlay { inherit erlang elixir elixir-otp; };
      finalPkgs = pkgs.extend overlay;
    in
    finalPkgs.callPackage lib/elixirDevShell.nix { inherit withLSP; };
}
