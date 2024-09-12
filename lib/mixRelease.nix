{
  pkgs,
  beamPackages,
  lib,
}:
{
  src,
  depsHash ? null,
  depsHashFile ? null,
  depsFile ? null,
  depsOverrides ? (x: y: { }),
  # phoenixSecret ? null,
  # phoenixSecretFile ? null,
  ...
}@attrs:
let
  # phx_secret =
  #   if phoenixSecret != null then
  #     phoenixSecret
  #   else if phoenixSecretFile != null then
  #     lib.strings.removeSuffix "\n" (builtins.readFile phoenixSecretFile)
  #   else
  #     null;

  deps_hash =
    if depsHash != null then
      depsHash
    else if depsHashFile != null then
      lib.strings.removeSuffix "\n" (builtins.readFile depsHashFile)
    else
      lib.fakeSha256;

  mixFodDeps = beamPackages.fetchMixDeps {
    pname = "mix-fod-deps";
    version = "0.0.1";
    inherit src;
    mixEnv = "";
    sha256 = deps_hash;
  };

  mixNixDeps = import depsFile {
    inherit beamPackages lib;
    overrides = depsOverrides;
  };

  deps = if depsFile != null then { inherit mixNixDeps; } else { inherit mixFodDeps; };

  metadata = pkgs.callPackage ./mixRelease/metadata.nix { inherit src; hex = beamPackages.hex;};

  customAttrs = [
    "phoenixSecret"
    "phoenixSecretFile"
  ];
  releaseAttrs = builtins.removeAttrs attrs customAttrs;
in
beamPackages.mixRelease (
  releaseAttrs
  // deps
  // {
    inherit (metadata) pname version;
    removeCookie = false;
  }
)
