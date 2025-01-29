{
  erlang ? null,
  elixir ? null,
  wxSupport ? true,
}:
pkgs:
let
  beamPackage = import ./beamPackage.nix;
  beamAttrSet = if wxSupport then pkgs.beam else pkgs.beam_nox;

  erlangPkg = beamPackage {
    name = "erlang";
    version = erlang;
    parentAttrSet = beamAttrSet.interpreters;
    inherit pkgs;
  };
  basePackages = beamAttrSet.packagesWith erlangPkg;

  elixirPkg = beamPackage {
    name = "elixir";
    version = elixir;
    parentAttrSet = basePackages;
    inherit pkgs;
  };
in
basePackages.extend (
  _: prev: {
    elixir = elixirPkg;

    # rebar3's checkPhase is long and sometimes deadlocks
    rebar3 = prev.rebar3.overrideAttrs { doCheck = false; };
  }
)
