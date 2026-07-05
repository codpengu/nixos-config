local setup, snacks = pcall(require, "snacks")
if not setup then
	return
end

snacks.setup({
	-- Better vim.ui.input with floating window + history navigation
	input = { enabled = true },

	-- Full fuzzy finder replacing telescope (except DAP pickers)
	picker = {
		enabled = true,
		layout = {
			preset = "telescope",
		},
		win = {
			input = {
				wo = { winblend = 0 },
				keys = {
					["<c-t>"] = { "trouble_open", mode = { "n", "i" } },
				},
			},
			list = { wo = { winblend = 0 } },
			preview = { wo = { winblend = 0 } },
		},
	},

	-- Indent guides + animated scope (replaces indent-blankline)
	indent = {
		enabled = true,
		indent = {
			char = "┊",
		},
		scope = {
			enabled = true,
		},
		animate = {
			enabled = false,
		},
		chunk = {
			enabled = false,
		},
	},

	-- vim.notify + LSP progress notifications (replaces fidget)
	notifier = {
		enabled = true,
		timeout = 3000,
		style = "compact",
	},

	-- Terminal toggling (replaces toggleterm)
	terminal = {
		enabled = true,
		start_insert = false,
		auto_insert = false,
		win = {
			style = "terminal",
			position = "bottom",
			height = 0.3,
		},
	},

	-- Lazygit floating window (replaces toggleterm lazygit terminal)
	lazygit = {
		enabled = true,
		start_insert = true,
		win = {
			position = "float",
			width = 0,
			height = 0,
			border = "rounded",
		},
	},

	-- GitHub CLI integration (issues, PRs, diffs)
	gh = { enabled = true },

	-- Auto-highlight all LSP references of symbol under cursor
	words = { enabled = true },

	-- Disable heavy features for large files
	bigfile = { enabled = true },

	-- Render file quickly before plugins fully load
	quickfile = { enabled = true },

	-- Disabled modules (using other plugins for these)
	statuscolumn = { enabled = false },
	scroll = { enabled = false },
	dashboard = { enabled = false },
	explorer = { enabled = false }, -- using nvim-tree
	zen = { enabled = false },
	scope = { enabled = false },
	dim = { enabled = false },
	animate = { enabled = false },
})

-- Expose Snacks globally so keymaps can use Snacks.picker.* etc.
_G.Snacks = snacks
