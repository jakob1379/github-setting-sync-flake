{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = [
    pkgs.nodejs_20
    (pkgs.callPackage ./default.nix {})
  ];
}
