{ pkgs ? import <nixpkgs> {} }:
with pkgs;
buildGoModule rec {
  name = "tmux-prompt-${version}";
  version = "1.0";
  modSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
  src = ./.;
}
