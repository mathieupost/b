{ nixpkgs ? <nixpkgs>, pkgs ? import nixpkgs { }, stdenv ? pkgs.stdenv
, ruby ? pkgs.ruby, runCommand ? pkgs.runCommand, symlinkJoin ? pkgs.symlinkJoin
, lib ? pkgs.lib, ndoc ? import ../ndoc { } }:

with lib;
let
  baseNameWithoutExtensionOf = path:
    concatStringsSep "." (init (splitString "." (baseNameOf path)));
  mkHTML = path:
    let
      name = baseNameWithoutExtensionOf path;
      mdName = name + ".md";
      htmlName = name + ".html";
    in runCommand name { } ''
      mkdir -p $out/$name
      ${ndoc}/bin/ndoc < ${path} > $out/$name/index.html
    '';
  mkIndex = files:
    runCommand "index.html" { nativeBuildInputs = [ ruby ndoc ]; } ''
      mkdir $out
      ${ruby}/bin/ruby ${./build-index} ${
        concatStringsSep " " files
      } | ${ndoc}/bin/ndoc > $out/index.html
    '';
in symlinkJoin {
  name = "notes";
  paths = let
    markdownFileNames = attrNames
      (filterAttrs (name: type: hasSuffix ".md" name) (builtins.readDir ./.));
    markdownFiles = map (fn: ./. + "/${fn}") markdownFileNames;
  in (map mkHTML markdownFiles) ++ [ (mkIndex markdownFiles) ];
}
