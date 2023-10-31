lib:
allSystems:
defaultSystems:
rec {
  inherit allSystems defaultSystems;
  asdfOverlay = import lib/asdfOverlay.nix lib;
  beamOverlay = import lib/beamOverlay.nix;

  devShell = { pkgs, src ? null, lsp ? pkgs.elixir-ls, erlang ? null, elixir ? null, elixir-otp ? erlang }:
    let
      overlay = beamOverlay { inherit erlang elixir elixir-otp; };
      finalPkgs = pkgs.extend overlay;
    in
    finalPkgs.callPackage lib/elixirDevShell.nix {
      inherit lsp src;
      erlang = finalPkgs.customErlang;
      elixir = finalPkgs.customElixir;
    };
}
