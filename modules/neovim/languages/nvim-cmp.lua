local types = require("cmp.types")
local cmp = require("cmp")
local luasnip = require("luasnip")

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
	sources = {
		{
			name = "fuzzy_path",
			option = {
				fd_cmd = { "fd", "--hidden", "-t", "d", "-t", "f", "-d", "20", "-p" },
				fd_timeout_msec = 1500,
			},
		},
	},
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
})
