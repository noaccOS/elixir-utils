{ erlang
, elixir
, elixir-ls
, mkShell
, inotify-tools
, libnotify
, terminal-notifier
, darwin
, lib
, stdenv
, beam
, elixir-ls
, lsp ? elixir-ls
}:

let
  pkgsLinux = [ inotify-tools libnotify ];
  pkgsDarwin = with darwin.apple_sdk.frameworks; [ terminal-notifier CoreFoundation CoreServices ];
  withLSP = lsp != null;
in
mkShell {
  packages = [
    erlang
    elixir
  ] ++ lib.optional withLSP lsp
  ++ lib.optionals stdenv.isLinux pkgsLinux
  ++ lib.optionals stdenv.isDarwin pkgsDarwin;

  shellHook = ''
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export MIX_PATH="${beam.packages.erlang.hex}/lib/erlang/lib/hex/ebin"
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
  '' + lib.optionalString withLSP ''
    # VS Code language server configuration
    export ELS_INSTALL_PREFIX="${lsp}/lib"

    # VS Code extension crash workaround
    export ELS_MODE=language_server
    export ELS_SCRIPT="ElixirLS.LanguageServer.CLI.main()"

    # Emacs
    export PATH="$ELS_INSTALL_PREFIX:$PATH"
  '';
}
