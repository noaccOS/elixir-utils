lib:
allSystems:
defaultSystems:
rec {
  inherit allSystems defaultSystems;
  asdfOverlay = import lib/asdfOverlay.nix lib;
  beamOverlay = import lib/beamOverlay.nix;

  devShell = { pkgs, lsp ? pkgs.elixir-ls, erlang ? null, elixir ? null, elixir-otp ? erlang, wxSupport ? true }:
    let
      overlay = beamOverlay { inherit erlang elixir elixir-otp wxSupport; };
      finalPkgs = pkgs.extend overlay;
    in
    finalPkgs.callPackage lib/elixirDevShell.nix {
      inherit lsp;
      erlang = finalPkgs.customErlang;
      elixir = finalPkgs.customElixir;
    };
}
