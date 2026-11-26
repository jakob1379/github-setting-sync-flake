<div align="center">

# GitHub Settings Sync Flake

A Nix flake for [`github-settings-sync`](https://github.com/klcodanr/github-settings-sync),
a CLI that applies one JSON settings file to every matching repository in a GitHub organization.

<img src=".github/assets/settings-sync.svg" width="100%" alt="Animated diagram: github-settings-sync sends a settings.json with repository, collaborators, branch_protection and files sections through a --name-pattern &quot;api&quot; filter to each repository in my-org in turn. The four repositories whose names contain api are updated; web-app and legacy-cron are skipped. The run ends with the summary Total repositories: 6, Processed: 4, Skipped: 2.">

</div>

## What the tool does

You describe the settings once in a JSON file. `github-settings-sync` walks the
repositories of an organization one by one and, for each repository that passes
your filters, applies:

| Key in `settings.json` | Effect on each repository |
| --- | --- |
| `repository` | Repository options such as `has_issues`, `has_wiki`, `allow_squash_merge`, `delete_branch_on_merge` |
| `collaborators` | Adds collaborators and updates their roles (`admin`, `maintain`, `write`, `triage`, `read`). Never removes anyone |
| `branch_protection` | Protection rules per branch name, for example required reviews and status checks |
| `files` | Creates or updates files in the repository from local files, and skips files that already match |

Repositories that fail the filters are skipped, and the run ends with a count of
processed and skipped repositories. The full settings format is documented
upstream in [klcodanr/github-settings-sync](https://github.com/klcodanr/github-settings-sync).

## Try it

```bash
export GITHUB_TOKEN=ghp_...   # needs the repo and admin:org scopes
nix run github:jakob1379/github-setting-sync-flake -- \
  --org my-org --settings settings.json --dry-run
```

`--dry-run` prints what would change without touching any repository.

| Option | Purpose |
| --- | --- |
| `-o, --org <organization>` | GitHub organization (required) |
| `-s, --settings <path>` | JSON settings file (required) |
| `-n, --name-pattern <pattern>` | Only repositories whose name matches this regular expression |
| `-l, --label <label>` | Only repositories that have this label |
| `--language <language>` | Only repositories with this primary language |
| `-t, --token <token>` | Personal access token, instead of `GITHUB_TOKEN` |
| `-u, --base-url <url>` | API base URL, for GitHub Enterprise |
| `-d, --dry-run` | Show what would change without making changes |

When several filters are given, a repository must match all of them.

## Build

```bash
nix build .#github-settings-sync
./result/bin/github-settings-sync --help
```

`nix develop` opens a shell with the CLI and Node.js 20.

## NixOS usage

```nix
{
  inputs.github-settings-sync-flake.url = "github:jakob1379/github-setting-sync-flake";

  outputs = { nixpkgs, github-settings-sync-flake, ... }: {
    nixosConfigurations.hostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [{
        environment.systemPackages = [
          github-settings-sync-flake.packages.x86_64-linux.github-settings-sync
        ];
      }];
    };
  };
}
```

## Home Manager usage

```nix
{
  inputs.github-settings-sync-flake.url = "github:jakob1379/github-setting-sync-flake";

  outputs = { nixpkgs, home-manager, github-settings-sync-flake, ... }: {
    homeConfigurations."user" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      modules = [{
        home.packages = [
          github-settings-sync-flake.packages.x86_64-linux.github-settings-sync
        ];
      }];
    };
  };
}
```

## Flake outputs

For every system in `flake-utils.lib.eachDefaultSystem`:

| Output | Contents |
| --- | --- |
| `packages.<system>.github-settings-sync` | The CLI, version 1.0.1, built from the upstream `v1.0.1` tag |
| `packages.<system>.default` | Same package |
| `apps.<system>.default` | Runs `github-settings-sync`, used by `nix run` |
| `devShells.<system>.default` | Node.js 20 and the CLI |

Packages are built against `nixos-24.05`.

## Attribution

This flake only packages the tool. `github-settings-sync` is written and
maintained by [klcodanr](https://github.com/klcodanr) at
[github.com/klcodanr/github-settings-sync](https://github.com/klcodanr/github-settings-sync)
and is released under the MIT license.
