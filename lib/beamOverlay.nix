{ erlang ? null
, elixir ? null
, elixir-otp ? erlang
, wxSupport ? true
}:
final: prev:
let
  beamPackage = import ./beamPackage.nix;
  beamAttrSet = if wxSupport then prev.beam else prev.beam_nox;

  customElixirOTP = beamPackage { name = "erlang"; version = elixir-otp; parentAttrSet = beamAttrSet.interpreters; pkgs = prev; };
  otpPackages = beamAttrSet.packagesWith customElixirOTP;

  customErlang = beamPackage { name = "erlang"; version = erlang; parentAttrSet = beamAttrSet.interpreters; pkgs = prev; };
  customElixir = beamPackage { name = "elixir"; version = elixir; parentAttrSet = otpPackages; pkgs = prev; };
  customElixirLS = (otpPackages.elixir-ls.override { elixir = customElixir; }).overrideAttrs (old: {
    buildPhase =
      # Elixir 1.16.0 or newer
      if (builtins.compareVersions customElixir.version "1.16.0" != -1)
      then ''
        runHook preBuild
        mix do compile --no-deps-check, elixir_ls.release2
        runHook postBuild
      ''
      else old.buildPhase;
  });
in
{
  inherit customElixir customErlang customElixirOTP;
  elixir-ls = customElixirLS;
  elixirDevShell = final.callPackage ./elixirDevShell.nix { erlang = customErlang; elixir = customElixir; };
  customMixRelease = final.callPackage ./mixRelease.nix { inherit customElixir customElixirOTP; };
}
