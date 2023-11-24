{ customElixir
, customElixirOTP
, beam
, lib
}:
{ src
, depsHash ? lib.fakeSha256
, phoenixSecret ? null
, phoenixSecretFile ? null
, ...
}@attrs:
let
  phx_secret =
    if phoenixSecret != null
    then phoenixSecret
    else if phoenixSecretFile != null
    then lib.strings.removeSuffix "\n" (builtins.readFile phoenixSecretFile)
    else null;

  erlPackages = beam.packagesWith customElixirOTP;
  mixFodDeps = erlPackages.fetchMixDeps {
    pname = "mix-fod-deps";
    version = "0.0.1";
    inherit src;
    sha256 = depsHash;
  };

  metadata = import ./mixRelease/metadata.nix {
    inherit src mixFodDeps lib;
    beamPackages = erlPackages;
    phoenixSecret = phx_secret;
  };

  customAttrs = [ "phoenixSecret" "phoenixSecretFile" ];
  releaseAttrs = builtins.removeAttrs attrs customAttrs;
in
erlPackages.mixRelease (releaseAttrs // {
  inherit (metadata) pname version;
  inherit mixFodDeps;
  removeCookie = false;

  # postBuild = ''
  #   mix do deps.loadpaths --no-deps-check, phx.digest
  #   mix phx.digest --no-deps-check
  # '';
})
