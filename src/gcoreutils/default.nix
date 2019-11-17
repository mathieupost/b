{ stdenvNoCC ? (import <nixpkgs> { }).stdenvNoCC
, coreutils ? (import <nixpkgs> { }).coreutils
, makeWrapper ? (import <nixpkgs> { }).makeWrapper }:
stdenvNoCC.mkDerivation {
  pname = "gcoreutils";
  version = "1.0.0";

  src = ./.;

  installPhase = ''
    . ${makeWrapper}/nix-support/setup-hook
    makeWrapper ${coreutils}/bin/ls $out/bin/gls
  '';
}
