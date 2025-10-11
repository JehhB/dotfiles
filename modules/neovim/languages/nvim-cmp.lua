local types = require("cmp.types")
local cmp = require("cmp")
local compare = require("cmp.config.compare")
local luasnip = require("luasnip")
local lspkind = require("cmp.types.lsp").CompletionItemKind

local function luasnip_supertab(select_opts)
	return cmp.mapping(function(fallback)
		local col = vim.fn.col(".") - 1

		if cmp.visible() then
			cmp.select_next_item(select_opts)
		elseif luasnip.expand_or_locally_jumpable() then
			luasnip.expand_or_jump()
		elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
			fallback()
		else
			cmp.complete()
		end
	end, { "i", "s" })
end

function luasnip_shift_supertab(select_opts)
	return cmp.mapping(function(fallback)
		if cmp.visible() then
			cmp.select_prev_item(select_opts)
		elseif luasnip.locally_jumpable(-1) then
			luasnip.jump(-1)
		else
			fallback()
		end
	end, { "i", "s" })
end

local folder_first_comparator = function(entry1, entry2)
	local kind1 = entry1.completion_item.kind
	local kind2 = entry2.completion_item.kind

	local is_folder1 = kind1 == lspkind.Folder
	local is_folder2 = kind2 == lspkind.Folder

	if is_folder1 and not is_folder2 then
		return true
	elseif not is_folder1 and is_folder2 then
		return false
	end

	return nil
end

cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
	},
	preselect = "item",
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = false }),
		["<Tab>"] = luasnip_shift_supertab(),
		["<S-Tab>"] = luasnip_shift_supertab(),
		["<C-n>"] = cmp.mapping.complete(),
	}),
	completion = {
		completeopt = "menu,menuone,noinsert",
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
})

cmp.setup.cmdline(":", {
	completion = {
		completeopt = "noselect",
	},
	sources = {
		{
			name = "fuzzy_path",
			option = {
				fd_cmd = { "fd", "--hidden", "-t", "d", "-t", "f", "-d", "20", "-p" },
				fd_timeout_msec = 1500,
			},
		},
	},
	preselect = cmp.PreselectMode.None,
	mapping = cmp.mapping.preset.cmdline({
		["<C-l>"] = {
			c = cmp.mapping.confirm({ select = false }),
		},
		["<Down>"] = {
			c = cmp.mapping.select_next_item({ behavior = types.cmp.SelectBehavior.Insert }),
		},
		["<Up>"] = {
			c = cmp.mapping.select_prev_item({ behavior = types.cmp.SelectBehavior.Insert }),
		},
	}),
	sorting = {
		priority_weight = 2,
		comparators = {
			folder_first_comparator,
			require("cmp_fuzzy_path.compare"),
			compare.offset,
			compare.exact,
			compare.score,
			compare.recently_used,
			compare.kind,
			compare.sort_text,
			compare.length,
			compare.order,
		},
	},
})
