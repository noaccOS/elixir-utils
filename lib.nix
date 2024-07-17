lib: allSystems: defaultSystems: rec {
  inherit allSystems defaultSystems;

  asdfOverlay = import lib/asdfOverlay.nix lib;
  beamOverlay = import lib/beamOverlay.nix;
  asdfPakcages = import lib/asdfPakcages.nix lib;
  beamPackages = import lib/beamPackages.nix;

  devShell =
    {
      pkgs,
      lsp ? pkgs.elixir-ls,
      erlang ? null,
      elixir ? null,
      wxSupport ? true,
    }:
    let
      overlay = beamOverlay { inherit erlang elixir wxSupport; };
      finalPkgs = pkgs.extend overlay;
    in
    finalPkgs.callPackage lib/elixirDevShell.nix { inherit lsp; };

  asdfDevShell =
    {
      pkgs,
      src,
      lsp ? pkgs.elixir-ls,
      wxSupport ? true,
    }:
    let
      asdf = import ./parseASDF.nix lib (src + "/.tool-versions");
    in
    pkgs.callPackage devShell {
      inherit lsp wxSupport;
      inherit (asdf) elixir erlang;
    };
}
