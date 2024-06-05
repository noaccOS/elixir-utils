lib:
{
  src,
  wxSupport ? true,
}:
let
  beamOverlay = import ./beamOverlay.nix;
  asdf = import ./parseASDF.nix lib (src + "/.tool-versions");
in
beamOverlay {
  inherit (asdf) elixir erlang;
  inherit wxSupport;
}
