{ erlang ? null
, elixir ? null
, elixir-otp ? erlang
}:
final: prev:
let
  beamPackage = import ./beamPackage.nix;

  customElixirOTP = beamPackage { name = "erlang"; version = elixir-otp; parentAttrSet = prev; pkgs = prev; };
  customErlang = beamPackage { name = "erlang"; version = erlang; parentAttrSet = prev; pkgs = prev; };
  customElixir = beamPackage { name = "elixir"; version = elixir; parentAttrSet = (prev.beam.packagesWith customElixirOTP); pkgs = prev; };
in
{
  inherit customElixir customErlang customElixirOTP;
  elixir-ls = (prev.elixir-ls.override { elixir = customElixir; });
  elixirDevShell = final.callPackage ./elixirDevShell.nix { erlang = customErlang; elixir = customElixir; };
  customMixRelease = final.callPackage ./mixRelease.nix { inherit customElixir customElixirOTP; };
}
