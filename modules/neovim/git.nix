{ ... }:
{
  programs.nixvim = {
    plugins.git-worktree = {
      enable = true;
      enableTelescope = true;
    };
    keymaps = [
      {
        mode = "n";
        key = "<leader>wt";
        action.__raw = "require('telescope').extensions.git_worktree.git_worktree";
      }
    ];
  };
}
