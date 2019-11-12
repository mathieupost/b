{ buildGoModule ? (import <nixpkgs> {}).buildGoModule
}:
buildGoModule {
  pname = "kaleidoscope-relay";
  version = "0.0.1";
  src = ./.;
  modSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";
  subPackages = [ "." ];
}
