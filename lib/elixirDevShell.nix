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
, lsp ? elixir-ls
}:

let
  beamPkgs = beam.packagesWith erlang;
  lspSetup = import ./lspSetupFor.nix lsp;
  pkgsLinux = [ inotify-tools libnotify ];
  pkgsDarwin = with darwin.apple_sdk.frameworks; [ terminal-notifier CoreFoundation CoreServices ];
in
mkShell {
  packages = [
    erlang
    elixir
  ] ++ lib.optional (lsp != null) lsp
  ++ lib.optionals stdenv.isLinux pkgsLinux
  ++ lib.optionals stdenv.isDarwin pkgsDarwin;

  shellHook = ''
    mkdir -p .nix-mix
    mkdir -p .nix-hex
    export MIX_HOME=$PWD/.nix-mix
    export HEX_HOME=$PWD/.nix-hex
    export MIX_PATH="${beamPkgs.hex}/lib/erlang/lib/hex/ebin"
    export PATH=$MIX_HOME/bin:$PATH
    export PATH=$HEX_HOME/bin:$PATH
    export LANG=en_US.UTF-8
  '' + lspSetup;
}
