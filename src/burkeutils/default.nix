{ stdenvNoCC ? (import <nixpkgs> {}).stdenvNoCC }:
stdenvNoCC.mkDerivation {
  pname = "burkeutils";
  version = "1.0.0";

  src = ./bin;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/* $out/bin
  '';
}
