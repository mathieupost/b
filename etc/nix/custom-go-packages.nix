{ buildGoModule, buildGoPackage, fetchFromGitHub, ... }:

{
  goimports = buildGoModule rec {
    pname = "goimports";
    version = "2020-11-02";

    src = fetchFromGitHub {
      owner = "golang";
      repo = "tools";
      rev = "f46e4245211d896a6356e27715f723d3d3de94f9";
      sha256 = "05mz083z015x5zqp8fgmk49r3ay36d2pw16z0xc0744bixrssxfd";
    };

    vendorSha256 = "18qpjmmjpk322fvf81cafkpl3spv7hpdpymhympmld9isgzggfyz"; 

    subPackages = [ "cmd/goimports" ]; 
  };
}
