{ nixpkgs ? <nixpkgs>
, pkgs ? import nixpkgs {}
, pandoc ? pkgs.pandoc
, stdenv ? pkgs.stdenv
, ruby ? pkgs.ruby
, makeWrapper ? pkgs.makeWrapper
, graphviz ? pkgs.graphviz
, gnuplot ? pkgs.gnuplot
, phantomjs ? pkgs.phantomjs
}:

let

  yarn2nix = import (builtins.fetchGit {
    url = "https://github.com/moretea/yarn2nix";
    rev = "9e7279edde2a4e0f5ec04c53f5cd64440a27a1ae";
  }) { inherit pkgs; };

  mathjaxNodeCLI = yarn2nix.mkYarnPackage {
    name = "mathjax-node-cli";
    src = ./filters/mathjax;
    packageJSON = ./filters/mathjax/package.json;
    yarnLock = ./filters/mathjax/yarn.lock;
  };

  mermaid = yarn2nix.mkYarnPackage {
    name = "mermaid";
    src = ./filters/mermaid;
    packageJSON = ./filters/mermaid/package.json;
    yarnLock = ./filters/mermaid/yarn.lock;
  };

in

stdenv.mkDerivation {
  name = "ndoc";
  src = ./.;
  buildPhase = "";
  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ ruby graphviz pandoc gnuplot mathjaxNodeCLI phantomjs mermaid ];
  installPhase = ''
    cp -r . $out
    chmod +x $out/bin/ndoc
    wrapProgram $out/bin/ndoc \
      --prefix PATH : ${pandoc}/bin \
      --prefix PATH : ${ruby}/bin \
      --prefix PATH : ${graphviz}/bin \
      --prefix PATH : ${gnuplot}/bin \
      --prefix PATH : ${phantomjs}/bin \
      --prefix PATH : ${mermaid}/bin \
      --prefix PATH : ${mathjaxNodeCLI}/bin
  '';
}

