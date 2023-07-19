lib:
rec {
  defaultSystems = [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "i686-linux" ];
  asdfOverlay = import lib/asdfOverlay.nix lib elixirDevShell;
  beamOverlay = import lib/beamOverlay.nix elixirDevShell;
  elixirDevShell = { pkgs, withLSP ? true, erlang ? null, elixir ? null, elixir-otp ? erlang }:
    let
      beamOverlay = import lib/beamOverlay.nix { inherit erlang elixir elixir-otp; };
      finalPkgs = pkgs.extend beamOverlay;
    in
    finalPkgs.callPackage lib/elixirDevShell.nix { inherit withLSP; };
}
