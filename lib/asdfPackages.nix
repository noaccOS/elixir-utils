lib:
{
  src,
  wxSupport ? true,
}:
let
  beamPackages = import ./beamPackages.nix;
  asdf = import ./parseASDF.nix lib (src + "/.tool-versions");
in
beamPackages {
  inherit (asdf) elixir erlang;
  inherit wxSupport;
}
