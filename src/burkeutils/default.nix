{ stdenvNoCC ? (import <nixpkgs> {}).stdenvNoCC
, ruby       ? (import <nixpkgs> {}).ruby
, bash       ? (import <nixpkgs> {}).bash
}:
stdenvNoCC.mkDerivation {
  pname = "burkeutils";
  version = "1.0.0";

  src = ./bin;

  buildinputs = [ ruby bash ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/* $out/bin
  '';
}
