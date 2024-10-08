lib: tool-versions:
let
  asdfVersion =
    asdfPackages: program:
    lib.strings.removePrefix "${program} " (
      lib.lists.findFirst (lib.strings.hasPrefix "${program} ") null asdfPackages
    );

  contents = builtins.readFile tool-versions;
  packages = lib.strings.splitString "\n" contents;
  erlangVersion = asdfVersion packages "erlang";
  elixirVersionFull = asdfVersion packages "elixir";
  elixirVersionComponents =
    if elixirVersionFull == null then
      [
        null
        null
      ]
    else
      lib.strings.splitString "-otp-" elixirVersionFull;

  # 26.0.2 -> 26
  erlangOTPVersion =
    if erlangVersion == null then null else builtins.head (lib.strings.splitString "." erlangVersion);
  # 14.0.5
  elixirVersion = builtins.head elixirVersionComponents;
  # 26
  elixirOTP = builtins.elemAt elixirVersionComponents 1;
in
assert erlangOTPVersion == elixirOTP;
{
  elixir = elixirVersion;
  erlang = erlangVersion;
}
