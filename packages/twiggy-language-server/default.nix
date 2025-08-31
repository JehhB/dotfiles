{
  buildNpmPackage,
  fetchurl,
  lib,
}:

buildNpmPackage rec {
  pname = "twiggy-language-server";
  version = "0.19.1";

  src = fetchurl {
    url = "https://registry.npmjs.org/twiggy-language-server/-/twiggy-language-server-${version}.tgz";
    hash = "sha256-zdV6WdzLfDRvrkfC3QDxQIxcoJUcElPiQH8uGykc7HQ=";
  };

  npmDepsHash = "sha256-Q8CxQzbAh1L6ltwNN6tskTCm3OAbSUroi90FYP/1Xl4=";

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
