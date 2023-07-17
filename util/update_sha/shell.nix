let
  pkgs = import <nixpkgs> {};
  python = pkgs.python3.withPackages (ps: [ps.requests]);
in
pkgs.mkShell {
  packages = [python pkgs.nix-prefetch-github];
}
