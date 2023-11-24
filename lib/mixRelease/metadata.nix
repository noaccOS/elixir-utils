{ beamPackages, mixFodDeps, src, phoenixSecret, lib }:
let
  metadata_derivation =
    beamPackages.mixRelease {
      inherit src mixFodDeps;
      pname = "mix-release-metadata";
      version = "0.0.1";

      postBuild = ''
        # we don't care what the secret is, but the build will complain if we don't include one
        export SECRET_KEY_BASE="$(mix phx.gen.secret)"
      '';

      installPhase = ''
        mkdir -p $out/share

        mix run -e 'IO.puts Mix.Project.config[:app]' --no-deps-check --no-start > $out/share/pname
        mix run -e 'IO.puts Mix.Project.config[:version]' --no-deps-check --no-start > $out/share/version
      '';
    };

  metadata_prefix = key: metadata_derivation + "/share/" + key;
  metadata = lib.trivial.flip lib.pipe [ metadata_prefix builtins.readFile (lib.strings.removeSuffix "\n") ];
in
{
  pname = metadata "pname";
  version = metadata "version";
}
