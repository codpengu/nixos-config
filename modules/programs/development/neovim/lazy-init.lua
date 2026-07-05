-- move this file to .config/nvim and rename it to init.lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local is_vscode = vim.g.vscode ~= nil

vim.opt.termguicolors = true

require("lazy").setup({
	-- Snacks: load first (non-lazy, high priority) so vim.notify + vim.ui.select
	-- are overridden before other plugins start
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		cond = not is_vscode,
	},

	{ "folke/which-key.nvim", cond = not is_vscode },
	{ "EdenEast/nightfox.nvim", cond = not is_vscode },

	{
		"hrsh7th/nvim-cmp",
		cond = not is_vscode,
		dependencies = {
			"L3MON4D3/LuaSnip",
			"rafamadriz/friendly-snippets",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
	},

	{ "folke/flash.nvim", cond = not is_vscode },

	{
		"folke/noice.nvim",
		cond = not is_vscode,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},

	{ "nvim-tree/nvim-tree.lua", cond = not is_vscode },

	{
		"nvim-telescope/telescope.nvim",
		cond = not is_vscode,
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		cond = not is_vscode,
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release -DCMAKE_POLICY_VERSION_MINIMUM=3.5 && cmake --build build --config=Release && cmake --install build",
	},
	{ "nvim-telescope/telescope-dap.nvim", cond = not is_vscode },

	{ "theHamsta/nvim-dap-virtual-text", cond = not is_vscode },
	{ "mfussenegger/nvim-dap", cond = not is_vscode },
	{ "rcarriga/nvim-dap-ui", cond = not is_vscode },
	{ "nvim-neotest/nvim-nio", cond = not is_vscode },

	{ "nvim-lualine/lualine.nvim", cond = not is_vscode },

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		cond = not is_vscode,
		dependencies = { "nvim-lua/plenary.nvim" },
	},

	{ "lewis6991/gitsigns.nvim", cond = not is_vscode },
	{ "norcalli/nvim-colorizer.lua", cond = not is_vscode },
	{ "rmagatti/auto-session", cond = not is_vscode },

	{ "iamcco/markdown-preview.nvim", cond = not is_vscode },
	{ "mrjones2014/legendary.nvim", cond = not is_vscode },
	{ "nvimtools/none-ls.nvim", cond = not is_vscode },
	{ "nvim-focus/focus.nvim", cond = not is_vscode },

	{
		"stevearc/aerial.nvim",
		cond = not is_vscode,
		opts = {},
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},

	{
		"pmizio/typescript-tools.nvim",
		cond = not is_vscode,
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},

	{ "mbbill/undotree", cond = not is_vscode },
	{ "sindrets/diffview.nvim", cond = not is_vscode },

	{
		"pwntester/octo.nvim",
		cond = not is_vscode,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
			"sindrets/diffview.nvim",
		},
	},

	{
		"folke/trouble.nvim",
		cond = not is_vscode,
		opts = {},
	},

	{
		"nvim-neotest/neotest",
		cond = not is_vscode,
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-neotest/neotest-jest",
			"marilari88/neotest-vitest",
			{
				"rcasia/neotest-java",
				dependencies = {
					"mfussenegger/nvim-jdtls",
					"mfussenegger/nvim-dap",
					"rcarriga/nvim-dap-ui",
					"theHamsta/nvim-dap-virtual-text",
				},
			},
		},
	},

	{ "nvim-neotest/neotest-jest", cond = not is_vscode },
	{ "marilari88/neotest-vitest", cond = not is_vscode },

	{
		"folke/lazydev.nvim",
		cond = not is_vscode,
		ft = "lua",
		opts = {},
	},

	{ "windwp/nvim-autopairs", cond = not is_vscode },
	{ "windwp/nvim-ts-autotag", cond = not is_vscode },

	{
		"ThePrimeagen/refactoring.nvim",
		cond = not is_vscode,
		dependencies = {
			"lewis6991/async.nvim",
			"nvim-lua/plenary.nvim",
		},
		lazy = false,
		config = function()
			require("refactoring").setup()
		end,
	},

	-- Search and replace
	{ "MagicDuck/grug-far.nvim", cond = not is_vscode },

	-- Surround motions (ys/cs/ds)
	{ "kylechui/nvim-surround", cond = not is_vscode, opts = {} },

	-- Git
	{ "tpope/vim-fugitive", cond = not is_vscode },
	{ "junegunn/gv.vim", cond = not is_vscode },

	-- LSP
	{ "neovim/nvim-lspconfig", cond = not is_vscode },
	{ "mfussenegger/nvim-jdtls", cond = not is_vscode },

	-- Icons
	{ "nvim-tree/nvim-web-devicons", cond = not is_vscode },

	-- Misc
	{ "nvim-lua/plenary.nvim" },
	{ "tpope/vim-repeat", cond = not is_vscode },
})

require("codpengu")
