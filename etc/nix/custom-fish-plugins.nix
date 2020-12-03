{ pkgs, ... }:

{
  z = {
    name = "z";
    src = pkgs.fetchFromGitHub {
      owner = "jethrokuan";
      repo = "z";
      rev = "78861a85fc4da704cd7d669c1133355c89a4c667";
      sha256 = "1ffjihdjbj3359hjhg2qw2gfx5h7rljlz811ma0a318nkdcg1asx";
    };
  };

  fzf = {
    name = "fzf";
    src = pkgs.fetchFromGitHub {
      owner = "jethrokuan";
      repo = "fzf";
      rev = "c2895ba0a83543f6aa29086989d0b735c7943067";
      sha256 = "1ydx0gv4mdnik8d4ymyckz9zkmiikq4xi0h4agca3sng87skwmw8";
    };
  };
}
