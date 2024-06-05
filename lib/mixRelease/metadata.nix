{
  mkDerivation,
  elixir,
  src,
  lib,
}:
let
  metadata_derivation = mkDerivation {
    pname = "mix-release-metadata";
    version = "0.0.1";
    inherit src;

    doBuild = false;
    nativeBuildInputs = [ elixir ];

    installPhase = ''
      mkdir -p $out/share

      mix run -e 'IO.puts Mix.Project.config[:app]' --no-deps-check --no-start --no-compile --no-elixir-version-check > $out/share/pname
      mix run -e 'IO.puts Mix.Project.config[:version]' --no-deps-check --no-start --no-compile --no-elixir-version-check > $out/share/version
    '';
  };

  metadata_prefix = key: metadata_derivation + "/share/" + key;
  metadata = lib.trivial.flip lib.pipe [
    metadata_prefix
    builtins.readFile
    (lib.strings.removeSuffix "\n")
  ];
in
{
  pname = metadata "pname";
  version = metadata "version";
}
