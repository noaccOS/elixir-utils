{ name, version, parentAttrSet }:
let
  allMinors = builtins.fromJSON (builtins.readFile ../beam-lock/${name}.json);
  minorAttrs = allMinors.${version};

  # 1.14 -> 1_14
  # 26 -> 26
  defaultMinorVersion = builtins.replaceStrings [ "." ] [ "_" ] version;
  defaultMinor = parentAttrSet."${name}_${defaultMinorVersion}";
  versionedPackage = parentAttrSet."${name}_${minorAttrs.minor}".override {
    version = minorAttrs.version;
    sha256 = minorAttrs.sha256;
  };

  customDerivation = version;
  versioned = if builtins.hasAttr version allMinors then versionedPackage else defaultMinor;
in
{
  set = customDerivation;
  string = versioned;
}.${builtins.typeOf version}
