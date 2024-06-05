lib:
{ src, wxSupport ? true }:
let
  beamOverlay = import ./beamOverlay.nix;
  asdf = import ./parseASDF.nix lib (src + "/.tool-versions");
in
beamOverlay { inherit (asdf) erlang elixir elixir-otp; inherit wxSupport; }
