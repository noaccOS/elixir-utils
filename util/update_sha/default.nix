{ stdenvNoCC, jq }:
stdenvNoCC.mkDerivation rec {
  name = "beamShaUpdater";
  src = ./.;

  installPhase = ''
    install -Dm 775 update-sha.sh -T $out/bin/${name}

    substituteInPlace $out/bin/${name} \
        --replace jq ${jq}/bin/jq
  '';
}
