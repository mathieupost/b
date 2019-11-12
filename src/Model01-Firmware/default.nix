{ stdenv      ? (import <nixpkgs> {}).stdenv
, callPackage ? (import <nixpkgs> {}).callPackage
}:
let
  Kaleidoscope-Bundle-Keyboardio = callPackage ./hardware.nix { };
in

stdenv.mkDerivation {
  pname = "Model01-Firmware";
  version = "0.0.1";

  nativeBuildInputs = [ Kaleidoscope-Bundle-Keyboardio ];

  src = ./.;
}
