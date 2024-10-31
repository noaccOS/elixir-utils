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
      erlang ? pkgs.erlang,
      elixir ? pkgs.elixir,
      wxSupport ? true,
      ...
    }@args:
    let
      overlay = beamOverlay { inherit erlang elixir wxSupport; };
      finalPkgs = pkgs.extend overlay;
      extraArgs = lib.removeAttrs args [
        "pkgs"
        "lsp"
        "erlang"
        "elixir"
        "wxSupport"
      ];
    in
    finalPkgs.callPackage lib/elixirDevShell.nix { inherit lsp extraArgs; };

  asdfDevShell =
    {
      pkgs,
      src,
      ...
    }@args:
    let
      asdf = import lib/parseASDF.nix lib (src + "/.tool-versions");
      devShellArgs = args // {
        inherit (asdf) elixir erlang;
      };

    in
    pkgs.callPackage devShell devShellArgs;
}
