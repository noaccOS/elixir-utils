lib: allSystems: defaultSystems: rec {
  inherit allSystems defaultSystems;

  asdfOverlay = import lib/asdfOverlay.nix lib;
  beamOverlay = import lib/beamOverlay.nix;
  asdfPackages = import lib/asdfPakcages.nix lib;
  beamPackages = import lib/beamPackages.nix;

  devShell =
    {
      pkgs,
      lsp ? null,
      erlang ? pkgs.erlang,
      elixir ? pkgs.elixir,
      wxSupport ? true,
      ...
    }@args:
    let
      overlay = beamOverlay { inherit erlang elixir wxSupport; };
      finalPkgs = pkgs.extend overlay;
      lspPackage =
        {
          elixir-ls = finalPkgs.elixir-ls;
          lexical = finalPkgs.lexical;
        }
        .${lsp} or null;
      extraArgs = lib.removeAttrs args [
        "pkgs"
        "lsp"
        "erlang"
        "elixir"
        "wxSupport"
      ];
    in
    finalPkgs.callPackage lib/elixirDevShell.nix {
      inherit extraArgs;
      lsp = lspPackage;
    };

  asdfDevShell =
    {
      pkgs,
      ...
    }@args:
    assert (
      lib.assertMsg (!(args ? src)) ''
        "src" has been deprecated in favor of "toolVersions". toolVersions should be the .tool-versions file itself.
      ''
    );
    let
      asdf = import lib/parseASDF.nix lib args.toolVersions;
      devShellArgs = args // {
        inherit (asdf) elixir erlang;
      };

    in
    pkgs.callPackage devShell devShellArgs;
}
