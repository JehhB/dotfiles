{ ... }:
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
  };
}
