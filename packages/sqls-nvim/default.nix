{
  vimUtils,
  fetchFromGitHub,
  lib,
}:

vimUtils.buildVimPlugin {
  pname = "sqls-nvim";
  version = "2024-09-17";

  src = fetchFromGitHub {
    owner = "nanotee";
    repo = "sqls.nvim";
    rev = "4b1274b5b44c48ce784aac23747192f5d9d26207";
    sha256 = "jKFut6NZAf/eIeIkY7/2EsjsIhvZQKCKAJzeQ6XSr0s=";
  };

  meta = {
    description = "Neovim plugin for sqls that leverages the built-in LSP client ";
    homepage = "https://github.com/nanotee/sqls.nvim";
    license = lib.licenses.mit;
  };
}
