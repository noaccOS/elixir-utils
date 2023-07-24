{ name, version, parentAttrSet, pkgs }:
let
  allMinors = builtins.fromJSON (builtins.readFile ../${name}-lock.json);
  minorAttrs = allMinors.${version};
  url = {
    erlang = "https://github.com/erlang/otp.git";
    elixir = "https://github.com/elixir-lang/elixir.git";
  }.${name};

  # 1.14 -> 1_14
  # 26 -> 26
  defaultMinorVersion = builtins.replaceStrings [ "." ] [ "_" ] version;
  defaultMinor = parentAttrSet."${name}_${defaultMinorVersion}";
  versionedPackage = parentAttrSet."${name}_${minorAttrs.minor}".override {
    version = minorAttrs.version;
    src = builtins.fetchGit {
      inherit url;
      inherit (minorAttrs) ref rev;
    };
  };

  customDerivation = version;
  versioned = if builtins.hasAttr version allMinors then versionedPackage else defaultMinor;

  defaultName = { erlang = "customErlang"; elixir = "customElixir"; }.${name};
  default = pkgs.${defaultName} or pkgs.${name};
in
{
  set = customDerivation;
  string = versioned;
  null = default;
}.${builtins.typeOf version}
