{
  description = "Kubernetes API Fetch Example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    flakeUtils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flakeUtils }:
    flakeUtils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ] (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      rec {
        devShell = pkgs.mkShellNoCC {
          buildInputs = builtins.attrValues {
            inherit (pkgs)
              nodejs-18_x
              ;
          };
        };
        defaultPackage = devShell.inputDerivation;
      }
    );
}
