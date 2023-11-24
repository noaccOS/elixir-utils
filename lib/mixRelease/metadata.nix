{ beamPackages, mixFodDeps, src }:
beamPackages.mixRelease {
  inherit src mixFodDeps;
  pname = "mix-release-metadata";
  version = "0.0.1";

  installPhase = ''
    mkdir -p $out/share

    mix run -e 'IO.puts Mix.Project.config[:app]' --no-deps-check > $out/share/pname
    mix run -e 'IO.puts Mix.Project.config[:version]' --no-deps-check > $out/share/version
  '';
}
