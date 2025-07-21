require("gruvbox-material").setup({
	italics = true,
	contrast = "hard",
	comments = {
		italics = true,
	},
	background = {
		transparent = false,
	},
	float = {
		force_background = false,
		background_color = nil,
	},
	signs = {
		highlight = true,
	},
	customize = nil,
})

vim.o.termguicolors = true
vim.o.background = "dark"
