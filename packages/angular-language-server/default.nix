{
  buildNpmPackage,
  fetchurl,
  lib,
}:

buildNpmPackage rec {
  pname = "angular-language-server";
  version = "18.2.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/@angular/language-server/-/language-server-${version}.tgz";
    hash = "sha256-UvYOxs59jOO9Yf0tvX96P4R/36qPeEne+NQAFkg9Eis=";
  };

  npmDepsHash = "sha256-avuVL7PI2uP5Y9hdHRCs10pBYUkTG0W6gqwZjM11Wjc=";

  postPatch = ''
    cp -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    description = "Official Angular language server";
    homepage = "https://github.com/angular/vscode-ng-language-service#readme";
    changelog = "https://github.com/angular/vscode-ng-language-service/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "angular-language-server";
  };
}
