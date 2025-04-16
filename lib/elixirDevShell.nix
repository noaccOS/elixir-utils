{
  erlang,
  elixir,
  beamPackages,
  mkShell,
  inotify-tools,
  libnotify,
  terminal-notifier,
  darwin,
  lib,
  stdenv,
  lsp ? null,
  extraArgs ? {},
  ...
}:

let
  lspSetup = import ./lspSetupFor.nix lsp;
  pkgsLinux = [
    inotify-tools
    libnotify
  ];
  pkgsDarwin = with darwin.apple_sdk.frameworks; [
    terminal-notifier
    CoreFoundation
    CoreServices
  ];
in
mkShell (extraArgs // {
  packages =
    [
      erlang
      elixir
    ]
    ++ (extraArgs.packages or [])
    ++ lib.optional (lsp != null) lsp
    ++ lib.optionals stdenv.isLinux pkgsLinux
    ++ lib.optionals stdenv.isDarwin pkgsDarwin;

  shellHook =
    ''
      mkdir -p .nix-mix
      mkdir -p .nix-hex
      export MIX_HOME=$PWD/.nix-mix
      export HEX_HOME=$PWD/.nix-hex
      export MIX_PATH="${beamPackages.hex}/lib/erlang/lib/hex/ebin"
      export PATH=$MIX_HOME/bin:$PATH
      export PATH=$HEX_HOME/bin:$PATH
      export LANG=en_US.UTF-8
    ''
    + lspSetup
    + (extraArgs.shellHook or "");
})
