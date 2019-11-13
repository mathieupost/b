{ stdenvNoCC ? (import <nixpkgs> {}).stdenvNoCC
, ruby       ? (import <nixpkgs> {}).ruby
}:
stdenvNoCC.mkDerivation {
  name = "b";
  src = ./.;
  buildPhase = "";
  installPhase = ''
    mkdir -p $out
    cp -a bin lib vendor $out
    chmod +x $out/bin/b
  '';
}
