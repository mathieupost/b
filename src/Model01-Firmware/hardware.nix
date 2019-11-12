{ stdenv          ? (import <nixpkgs> {}).stdenv
, fetchFromGitHub ? (import <nixpkgs> {}).fetchFromGitHub
}:
stdenv.mkDerivation {
  pname = "Kaleidoscope-Bundle-Keyboardio";
  version = "0.0.1";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "keyboardio";
    repo = "Kaleidoscope-Bundle-Keyboardio";
    rev = "475659a6e36cec3142f3cdceffa6e166332d8a5b";
    sha256 = "0n2f82xxrxvdw7c5kqcdp611wmn38q1x1pnkjigskx8g1v1klwwj";
  };

  buildPhase = "";

  installPhase = ''
    mkdir $out
    mv * $out
  '';
}
