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
  _: _: {
    erlang = erlangPkg;
    elixir = elixirPkg;
  }
)
