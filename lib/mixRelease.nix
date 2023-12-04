{ customElixir
, customElixirOTP
, beam
, lib
}:
{ src
, depsHash ? null
, depsHashFile ? null
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

  deps_hash =
    if depsHash != null
    then depsHash
    else if depsHashFile != null
    then lib.strings.removeSuffix "\n" (builtins.readFile depsHashFile)
    else lib.fakeSha256;

  erlPackages = beam.packagesWith customElixirOTP;
  mixFodDeps = erlPackages.fetchMixDeps {
    pname = "mix-fod-deps";
    version = "0.0.1";
    inherit src;
    mixEnv = "";
    sha256 = deps_hash;
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
})
