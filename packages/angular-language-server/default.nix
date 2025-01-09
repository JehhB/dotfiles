{
  buildNpmPackage,
  fetchurl,
  lib,
}:

buildNpmPackage rec {
  pname = "angular-language-server";
  version = "19.0.3";

  src = fetchurl {
    url = "https://registry.npmjs.org/@angular/language-server/-/language-server-${version}.tgz";
    hash = "sha256-qL+RA3OvJumx049biS+2SfyE/OyhQHJ4KaX5NRTgwoM=";
  };

  npmDepsHash = "sha256-9aQ5NmZYhkIoihkUwTapZG6NCwtLnTYgqY9/Xs4X9ew=";

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
