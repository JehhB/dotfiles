{ config, lib, ... }:
{
  programs.nixvim = {
    plugins = {
      luasnip.enable = true;
      hardtime = {
        enable = true;
        settings = {
          disable_mouse = false;
          max_time = 7500;
          max_count = 2;
        };
      };
    };
  };

  programs.nixvim = {
    plugins = {
      cmp = {
        enable = true;
        luaConfig.pre = ''
          local luasnip = require("luasnip")
          local cmp_types = require("cmp.types")
          local cmp_compare = require("cmp.config.compare")
        '';
        settings = {
          preselect = "cmp.PreselectMode.Item";
          sources = [
            { name = "copilot"; }
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          sorting = {
            priority_weight = 2;
            comparators = [
              "require('copilot_cmp.comparators').prioritize"
              "cmp_compare.offset"
              "cmp_compare.exact"
              "cmp_compare.score"
              "cmp_compare.recently_used"
              "cmp_compare.kind"
              "cmp_compare.sort_text"
              "cmp_compare.length"
              "cmp_compare.order"
            ];
          };
          snippet.expand = # lua
            ''
              function(args)
                luasnip.lsp_expand(args.body)
              end
            '';
          mapping.__raw = ''
            cmp.mapping.preset.insert({
              ['<CR>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  if luasnip.expandable() then
                    luasnip.expand()
                  else
                    cmp.confirm({
                      select = true,
                    })
                  end
                else
                  fallback()
                end
              end),

              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif luasnip.locally_jumpable(1) then
                  luasnip.jump(1)
                else
                  fallback()
                end
              end, { "i", "s" }),

              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif luasnip.locally_jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<C-n>"] = cmp.mapping.complete(),
            })
          '';
          completeopt = "menu,menuone,noinsert";
        };
        cmdline.":" = {
          completion = {
            completeopt = "noselect";
          };
          sources = [
            {
              name = "fuzzy_path";
              option = {
                fd_cmd = [
                  "fd"
                  "--hidden"
                  "-t"
                  "d"
                  "-t"
                  "f"
                  "-d"
                  "20"
                  "-p"
                ];
                fd_timeout_msec = 1500;
              };
            }
            { name = "cmdline"; }
          ];
          mapping.__raw = ''
            cmp.mapping.preset.cmdline({
              ["<C-l>"] = {
                c = cmp.mapping.confirm({ select = false }),
              },
              ["<Down>"] = {
                c = cmp.mapping.select_next_item({ behavior = cmp_types.cmp.SelectBehavior.Insert }),
              },
              ["<Up>"] = {
                c = cmp.mapping.select_prev_item({ behavior = cmp_types.cmp.SelectBehavior.Insert }),
              },
            })
          '';
          sorting = {
            comparators = [
              # lua
              ''
                function(entry1, entry2)
                  local kind1 = entry1.completion_item.kind
                  local kind2 = entry2.completion_item.kind

                  local is_folder1 = kind1 == cmp_types.lsp.CompletionItemKind.Folder
                  local is_folder2 = kind2 == cmp_types.lsp.CompletionItemKind.Folder

                  if is_folder1 and not is_folder2 then
                    return true
                  elseif not is_folder1 and is_folder2 then
                    return false
                  end

                  return nil
                end
              ''
              "require('cmp_fuzzy_path.compare')"
              "cmp_compare.offset"
              "cmp_compare.exact"
              "cmp_compare.score"
              "cmp_compare.recently_used"
              "cmp_compare.kind"
              "cmp_compare.sort_text"
              "cmp_compare.length"
              "cmp_compare.order"
            ];
          };
        };
        cmdline."/" = {
          completion = {
            completeopt = "noselect";
          };
          sources = [
            { name = "buffer"; }
          ];
          mapping.__raw = ''
            cmp.mapping.preset.cmdline({
              ["<C-l>"] = {
                c = cmp.mapping.confirm({ select = false }),
              },
              ["<Down>"] = {
                c = cmp.mapping.select_next_item({ behavior = cmp_types.cmp.SelectBehavior.Insert }),
              },
              ["<Up>"] = {
                c = cmp.mapping.select_prev_item({ behavior = cmp_types.cmp.SelectBehavior.Insert }),
              },
            })
          '';
        };

      };
    };
  };
}
