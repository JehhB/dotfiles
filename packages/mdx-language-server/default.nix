{
  buildNpmPackage,
  fetchurl,
  lib,
}:

buildNpmPackage rec {
  pname = "mdx-language-server";
  version = "0.6.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mdx-js/language-server/-/language-server-${version}.tgz";
    hash = "sha256-wu33fffEJmLj7GOOjuf/nvCkH2ZDdCZ9y9iNnFYQ5ss=";
  };

  npmDepsHash = "sha256-qi8bmoN3CqHbR9rNbm1sDmJJuaqgEloTOqpKlzt1hiM=";

  postPatch = ''
    cp -s ${./package-lock.json} package-lock.json
  '';

  dontNpmBuild = true;

  meta = {
    description = "A language server for MDX.";
    homepage = "https://mdxjs.com/";
    changelog = "github.com/mdx-js/mdx-analyzer";
    license = lib.licenses.mit;
    mainProgram = "mdx-language-server";
  };
}
