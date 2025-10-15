{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "github-settings-sync";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "klcodanr";
    repo = "github-settings-sync";
    rev = "v${version}";
    hash = "sha256-TpYFHavvJe6CYpVeGkNPwyPKcefGMQ9Cw1By+Skd6Cc=";
  };

  npmDepsHash = "sha256-YDA3U5GJDFkwESB7hHSB6GXxiMxfj0ZIPmkmiMC5pAI=";
  dontNpmBuild = true;

  meta = {
    description = "Synchronize GitHub repository settings across multiple repositories";
    homepage = "https://github.com/klcodanr/github-settings-sync";
    changelog = "https://github.com/klcodanr/github-settings-sync/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "github-settings-sync";
    platforms = lib.platforms.all;
  };
}
