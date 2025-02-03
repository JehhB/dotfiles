{
  vimUtils,
  fetchFromGitHub,
  lib,
}:

vimUtils.buildVimPlugin {
  pname = "treesitter-mdx-nvim";
  version = "2024-09-17";

  src = fetchFromGitHub {
    owner = "davidmh";
    repo = "mdx.nvim";
    rev = "ae83959b61a9fec8da228ebb5d6b045fd532d2cc";
    sha256 = "z835i8QkQFe185sgSLtUaaTsMs2Px9x6KTObTRAOFz0=";
  };

  meta = {
    description = "Good enough syntax highlight for MDX in Neovim using Treesitter ";
    homepage = "https://github.com/davidmh/mdx.nvim";
    license = lib.licenses.mit;
  };
}
