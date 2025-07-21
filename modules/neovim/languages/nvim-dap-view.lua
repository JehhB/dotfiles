local dap_view = require("dap-view")

dap_view.setup({
	auto_toggle = true,
	winbar = {
		show = true,
		sections = { "console", "breakpoints", "watches", "scopes", "exceptions", "threads", "repl" },
		default_section = "breakpoints",
	},
})

vim.keymap.set("n", "<leader>dc", function()
	dap_view.jump_to_view("console")
end)

vim.keymap.set("n", "<leader>db", function()
	dap_view.jump_to_view("breakpoints")
end)

vim.keymap.set("n", "<leader>de", function()
	dap_view.jump_to_view("exceptions")
end)

vim.keymap.set("n", "<leader>dw", function()
	dap_view.jump_to_view("watches")
end)

vim.keymap.set("n", "<leader>dr", function()
	dap_view.jump_to_view("repl")
end)

vim.keymap.set("n", "<leader>dt", function()
	dap_view.jump_to_view("threads")
end)

vim.keymap.set("n", "<leader>ds", function()
	dap_view.jump_to_view("scopes")
end)
