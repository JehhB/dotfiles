{
  buildNpmPackage,
  fetchurl,
  lib,
}:

buildNpmPackage rec {
  pname = "mdx-language-server";
  version = "0.5.2";

  src = fetchurl {
    url = "https://registry.npmjs.org/@mdx-js/language-server/-/language-server-${version}.tgz";
    hash = "sha256-8ef9dVVsH5yTva9ymY+EAZTz6FOZ7Zgu9kOv1wLaK4w=";
  };

  npmDepsHash = "sha256-HOHjASspb3+RLF7yRwdIOKzspSe0ZGKDe6rQHtOziws=";

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
