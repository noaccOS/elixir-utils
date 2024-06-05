{
  erlang ? null,
  elixir ? null,
  wxSupport ? true,
}:
final: prev:
let
  beamPackages = import ./beamPackages { inherit erlang elixir wxSupport; } prev;
in
{
  inherit beamPackages;
  inherit (beamPackages)
    elixir
    erlang
    elixir-ls
    ex_doc
    erlang-ls
    erlfmt
    elvis-erlang
    rebar
    rebar3
    rebar3WithPlugins
    fetchHex
    lfe
    lfe_2_1
    ;
  elixirDevShell = final.callPackage ./elixirDevShell.nix { };
  mixRelease = final.callPackage ./mixRelease.nix { };
}
