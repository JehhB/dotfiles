{ pkgs, ... }:
{
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = true;
      lazyLoad.settings = {
        cmd = "Copilot";
        event = [ "InsertEnter" ];
        after.__raw = ''
          function()
            require("copilot").setup({
              suggestion = { enabled = false },
              panel = { enabled = false },
            })

            print("Copilot started")
          end
        '';
      };

    };

    plugins.copilot-cmp.enable = true;

    plugins.copilot-chat = {
      enable = true;
      luaConfig.post = ''
        vim.api.nvim_create_autocmd("BufEnter", {
          pattern = "copilot-*",
          callback = function()
            vim.keymap.set("n", "<Esc>", '<cmd>CopilotChatClose<cr>', { buffer = true })
          end,
        })
      '';
      settings = {
        model = "gpt-4.1";
        temperature = 0.1;
        auto_insert_mode = true;
        window = {
          layout = "vertical";
          width = 72;
        };
      };
    };
    keymaps = [
      {
        mode = [
          "v"
          "n"
        ];
        key = "<leader>cc";
        action = "<cmd>CopilotChatToggle<cr>";
      }
      {
        mode = [
          "v"
          "n"
        ];
        key = "<leader>cC";
        action = "<cmd>CopilotChatPrompts<cr>";
      }
      {
        mode = [
          "v"
          "n"
        ];
        key = "<leader>ce";
        action = "<cmd>CopilotChatExplain<cr>";
      }
      {
        mode = [
          "v"
          "n"
        ];
        key = "<leader>cd";
        action = "<cmd>CopilotChatFix<cr>";
      }
      {
        mode = [
          "v"
          "n"
        ];
        key = "<leader>ci";
        action = "<cmd>CopilotChatOptimize<cr>";
      }
      {
        mode = [
          "v"
          "n"
        ];
        key = "<leader>cr";
        action = "<cmd>CopilotChatReview<cr>";
      }
    ];

    lsp.servers.copilot = {
      enable = true;
      package = pkgs.copilot-language-server;
    };
  };
}
