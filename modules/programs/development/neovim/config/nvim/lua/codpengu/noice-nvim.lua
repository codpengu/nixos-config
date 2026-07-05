local setup, plugin = pcall(require, "noice")
if not setup then
	return
end

plugin.setup({
	views = {
		cmdline_popup = { win_options = { winblend = 0 } },
		popupmenu = { win_options = { winblend = 0 } },
		hover = { win_options = { winblend = 0 } },
		confirm = { win_options = { winblend = 0 } },
		mini = { win_options = { winblend = 0 } },
	},
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		hover = {
			enabled = true,
		},
		signature = {
			enabled = true,
			auto_open = {
				enabled = true,
				trigger = true,
				luasnip = true,
				throttle = 50,
			},
		},
		message = {
			enabled = true,
			view = "notify",
			opts = {},
		},
		-- Disabled: snacks.notifier handles LSP progress notifications
		progress = { enabled = false },
		documentation = {
			view = "hover",
			opts = {
				lang = "markdown",
				replace = true,
				render = "plain",
				format = { "{message}" },
				win_options = { concealcursor = "n", conceallevel = 3 },
			},
		},
	},
	-- Route JDTLS/inputlist confirm messages to the floating confirm popup
	routes = {
		{
			filter = { event = "msg_show", kind = "confirm" },
			view = "confirm",
		},
		{
			filter = { event = "msg_show", kind = "confirm_sub" },
			view = "confirm",
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
		inc_rename = false,
		lsp_doc_border = true,
	},
})
