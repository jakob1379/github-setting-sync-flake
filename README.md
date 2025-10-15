# GitHub Settings Sync Flake

## Attribution
This flake packages the `github-settings-sync` CLI maintained by [klcodanr](https://github.com/klcodanr) from [github.com/klcodanr/github-settings-sync](https://github.com/klcodanr/github-settings-sync).

## Overview
The flake exposes the tool as `packages.${system}.github-settings-sync`, making it easy to use within Nix-based environments.

## Build
```bash
nix build .#github-settings-sync
```

## NixOS Usage
```nix
{
  inputs.github-settings-sync-flake.url = "github:jsg/github-setting-sync-flake";

  outputs = { self, nixpkgs, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [{
        environment.systemPackages = [
          self.packages.${system}.github-settings-sync
        ];
      }];
    };
  };
}
```

## Home Manager Usage
```nix
{
  inputs.github-settings-sync-flake.url = "github:jsg/github-setting-sync-flake";

  outputs = { self, nixpkgs, home-manager, ... }: {
    homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
      inherit nixpkgs;
      modules = [{
        home.packages = [
          inputs.github-settings-sync-flake.packages.${system}.github-settings-sync
        ];
      }];
    };
  };
}
```
