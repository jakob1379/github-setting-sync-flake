{
  description = "Flake packaging for the github-settings-sync CLI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        package = pkgs.callPackage ./default.nix {};
      in {
        packages.default = package;

        apps.default = flake-utils.lib.mkApp {
          drv = package;
          exePath = "/bin/github-settings-sync";
        };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nodejs_20
            package
          ];
        };
      }
    );
}
