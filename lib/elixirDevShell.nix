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
, withLSP ? true
}:

let
  pkgsLinux = [ inotify-tools libnotify ];
  pkgsDarwin = with darwin.apple_sdk.frameworks; [ terminal-notifier CoreFoundation CoreServices ];
in
mkShell {
  packages = [
    erlang
    elixir
  ] ++ lib.optional withLSP elixir-ls
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
    export ELS_INSTALL_PREFIX="${elixir-ls}/lib"

    # VS Code extension crash workaround
    export ELS_MODE=language_server
    export ELS_SCRIPT="ElixirLS.LanguageServer.CLI.main()"

    # Emacs
    export PATH="$ELS_INSTALL_PREFIX:$PATH"
  '';
}
