{ stdenv   ? (import <nixpkgs> {}).stdenv
, fetchzip ? (import <nixpkgs> {}).fetchzip
}:

stdenv.mkDerivation {
  pname = "arduino";
  version = "1.8.10";

  src = fetchzip {
    url = "https://downloads.arduino.cc/arduino-1.8.10-macosx.zip";
    sha256 = "0b0xkvbppkam8rq6sh9l9gvfvrip07avhz7a5jcr6m2d6nsz4imz";
  };

  installPhase = ''
    mkdir -p $out/Applications/Arduino.app
    mv ./* $out/Applications/Arduino.app
    chmod +x "$out/Applications/Arduino.app/Contents/MacOS/Arduino"
  '';

  # meta = {
  #   description = "Staggeringly powerful macOS desktop automation with Lua";
  #   license = stdenv.lib.licenses.mit;
  #   homepage = "https://www.hammerspoon.org";
  #   platforms = stdenv.lib.platforms.darwin;
  # };
}
