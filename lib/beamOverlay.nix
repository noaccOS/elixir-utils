{ erlang ? null
, elixir ? null
, elixir-otp ? erlang
}:
final: prev:
let
  beamPackage = import ./beamPackage.nix;

  elixirOTP = beamPackage { name = "erlang"; version = elixir-otp; parentAttrSet = prev; };
  customErlang = beamPackage { name = "erlang"; version = erlang; parentAttrSet = prev; };
  customElixir = beamPackage { name = "elixir"; version = elixir; parentAttrSet = (prev.beam.packagesWith elixirOTP); };

  finalErlang = if erlang == null then prev.erlang else customErlang;
  finalElixir = if elixir == null then prev.elixir else customElixir;
in
{
  erlang = finalErlang;
  elixir = finalElixir;
  elixir-ls = (prev.elixir-ls.override { elixir = finalElixir; });
}
