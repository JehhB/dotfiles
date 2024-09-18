{
  buildNpmPackage,
  fetchurl,
  lib,
}:

buildNpmPackage rec {
  pname = "twiggy-language-server";
  version = "0.14.0";

  src = fetchurl {
    url = "https://registry.npmjs.org/twiggy-language-server/-/twiggy-language-server-${version}.tgz";
    hash = "sha256-l9O0UEAIxQiqI9fcF1izBXEEC1G9UBZ61D6YMqNCwCY=";
  };

  npmDepsHash = "sha256-qOcmD7S4PPJsBYHF727IsPn7etW4jEgQFzMXv9SrKFI=";

  postPatch = ''
    cp -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    description = "TypeScript-powered language server for Twig templates.";
    homepage = "https://github.com/moetelo/twiggy";
    license = lib.licenses.mit;
    mainProgram = "angular-language-server";
  };
}
