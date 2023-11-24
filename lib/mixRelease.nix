{ customElixir
, customElixirOTP
, beam
, lib
}:
{ src
, depsHash ? lib.fakeSha256
, ...
}@attrs:
let
  erlPackages = beam.packagesWith customElixirOTP;
  mixFodDeps = erlPackages.fetchMixDeps {
    pname = "mix-fod-deps";
    version = "0.0.1";
    inherit src;
    sha256 = depsHash;
  };
  metadata = import ./mixRelease/metadata.nix { inherit src mixFodDeps; beamPackages = erlPackages; };
in
erlPackages.mixRelease (attrs // {
  inherit src mixFodDeps;
  pname = builtins.readFile (metadata + "share/pname");
  version = builtins.readFile (metadata + "share/version");
})
