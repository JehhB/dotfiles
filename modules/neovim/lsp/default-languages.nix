{ pkgs }:

{
  nix = {
    treesitterGrammars = p: [p.nix];
    extraPackages = [ pkgs.nil ];
    lspConfig = ''
    lspconfig.nil_ls.setup({
      cmd = { 'nil' },
      filetypes = { 'nix' },
    })
    '';
  };
}
