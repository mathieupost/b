{ stdenv   ? (import <nixpkgs> {}).stdenv
, fetchurl ? (import <nixpkgs> {}).fetchurl
, undmg    ? (import <nixpkgs> {}).undmg
}:

let
  appName = "Anki";
in

stdenv.mkDerivation {
  pname = "anki";
  version = "0.9.76";

  src = fetchurl {
    url = "https://apps.ankiweb.net/downloads/current/anki-2.1.15-mac.dmg";
    sha256 = "0l4sw46jfwz1l42d6bsrb78pi350na0prpvbizzy3bl4169khjhf";
  };

  buildInputs = [ undmg ];
  installPhase = ''
    mkdir -p $out/Applications/${appName}.app
    mv ./* $out/Applications/${appName}.app
    chmod +x "$out/Applications/${appName}.app/Contents/MacOS/${appName}"
  '';

  meta = {
    description = "Powerful, intelligent flash cards.";
    # license = stdenv.lib.licenses.mit;
    homepage = "https://apps.ankiweb.net";
    platforms = stdenv.lib.platforms.darwin;
  };
}
