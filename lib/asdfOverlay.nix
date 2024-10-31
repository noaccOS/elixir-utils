lib:
{
  wxSupport ? true,
  ...
}@args:
assert (
  lib.assertMsg (!(args ? src)) ''
    "src" has been deprecated in favor of "toolVersions". toolVersions should be the .tool-versions file itself.
  ''
);
let
  beamOverlay = import ./beamOverlay.nix;
  asdf = import ./parseASDF.nix lib args.toolVersions;
in
beamOverlay {
  inherit (asdf) elixir erlang;
  inherit wxSupport;
}
