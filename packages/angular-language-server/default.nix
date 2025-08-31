{
  buildNpmPackage,
  fetchurl,
  lib,
}:

buildNpmPackage rec {
  pname = "angular-language-server";
  version = "20.2.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@angular/language-server/-/language-server-${version}.tgz";
    hash = "sha256-94lHc4WEaZ8pWwUZaGUVIdmJdEJaezhA7F9XHx3rF4U=";
  };

  npmDepsHash = "sha256-Gw4UbqgIRYBlkBqR583QReyCBR4r80ahJ9NQhu7nhC4=";

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
