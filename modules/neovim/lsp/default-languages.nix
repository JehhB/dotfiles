{ pkgs }:

{
  nix = {
    treesitterGrammars = p: [ p.nix ];
    extraPackages = with pkgs; [
      nil
      nixfmt-rfc-style
    ];
    formatters = {
      nix = [ "nixfmt" ];
    };
    lspConfig = ''
      lspconfig.nil_ls.setup({
        cmd = { 'nil' },
        filetypes = { 'nix' },
      })
    '';
  };
}
