local setup, which_key = pcall(require, "which-key")
if not setup then
	return
end

local harpoon = require("harpoon")

vim.o.timeout = true
vim.o.timeoutlen = 300

-- NOTE: Prefer using : over <cmd> as the latter avoids going back in normal-mode.
-- see https://neovim.io/doc/user/map.html#:map-cmd
local vmappings = {
	{
		"<leader>/",
		"gc",
		desc = "Comment toggle (visual)",
		mode = "v",
		remap = true,
	},
	{
		"<leader>l",
		group = "LSP",
		mode = "v",
	},
	{
		"<leader>la",
		"<cmd>lua vim.lsp.buf.code_action()<cr>",
		desc = "Code Action",
		mode = "v",
	},
	{
		"<leader>r",
		group = "Find and replace",
		mode = "v",
	},
	{
		"<leader>ro",
		function()
			require("grug-far").with_visual_selection()
		end,
		desc = "Find under cursor",
		mode = "v",
	},
}

local mappings = {
	mode = "n",
	prefix = "<leader>",
	buffer = nil,
	silent = true,
	noremap = true,
	nowait = true,
	{
		"<leader>/",
		"gcc",
		desc = "Comment toggle current line",
		remap = true,
	},
	{
		"<leader>R",
		function()
			require("refactoring").select_refactor()
		end,
		desc = "Refactoring",
	},
	{
		"<leader>T",
		function()
			Snacks.terminal()
		end,
		desc = "Toggle terminal",
	},
	{
		"<leader>a",
		group = "Aerial",
	},
	{
		"<leader>aa",
		"<cmd>AerialToggle!<CR>",
		desc = "Toggle aerial",
	},
	{
		"<leader>c",
		"<cmd>bd<CR>",
		desc = "Close Buffer",
	},
	{
		"<leader>d",
		group = "Debug",
	},
	{
		"<leader>dC",
		"<cmd>lua require'dap'.run_to_cursor()<cr>",
		desc = "Debug run To Cursor",
	},
	{
		"<leader>dT",
		"<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>",
		desc = "Debug conditional breakpoint",
	},
	{
		"<leader>dU",
		"<cmd>lua require'dapui'.toggle({reset = true})<cr>",
		desc = "Debug toggle UI",
	},
	{
		"<leader>db",
		"<cmd>lua require'dap'.step_back()<cr>",
		desc = "Debug step Back",
	},
	{
		"<leader>dc",
		"<cmd>lua require'dap'.continue()<cr>",
		desc = "Debug continue",
	},
	{
		"<leader>dd",
		"<cmd>lua require'dap'.disconnect()<cr>",
		desc = "Debug disconnect",
	},
	{
		"<leader>df",
		function()
			require("jdtls").test_class()
		end,
		desc = "Debug test class",
	},
	{
		"<leader>dg",
		"<cmd>lua require'dap'.session()<cr>",
		desc = "Debug get Session",
	},
	{
		"<leader>di",
		"<cmd>lua require'dap'.step_into()<cr>",
		desc = "Debug step Into",
	},
	{
		"<leader>dn",
		function()
			require("jdtls").test_nearest_method()
		end,
		desc = "Debug nearest method",
	},
	{
		"<leader>do",
		"<cmd>lua require'dap'.step_over()<cr>",
		desc = "Debug step Over",
	},
	{
		"<leader>dp",
		"<cmd>lua require'dap'.pause()<cr>",
		desc = "Debug pause",
	},
	{
		"<leader>dq",
		"<cmd>lua require'dap'.close()<cr>",
		desc = "Debug quit",
	},
	{
		"<leader>dr",
		"<cmd>lua require'dap'.repl.toggle()<cr>",
		desc = "Debug toggle Repl",
	},
	{
		"<leader>ds",
		"<cmd>lua require'dap'.continue()<cr>",
		desc = "Debug start",
	},
	{
		"<leader>dt",
		"<cmd>lua require'dap'.toggle_breakpoint()<cr>",
		desc = "Toggle Breakpoint",
	},
	{
		"<leader>du",
		"<cmd>lua require'dap'.step_out()<cr>",
		desc = "Debug step Out",
	},
	{
		"<leader>e",
		"<cmd>NvimTreeToggle<CR>",
		desc = "Explorer",
	},
	{
		"<leader>f",
		group = "Find",
	},
	{
		"<leader>fA",
		"<cmd>Legendary<cr>",
		desc = "Find legendary commands",
	},
	{
		"<leader>fP",
		"<cmd>AutoSession search<cr>",
		desc = "Find projects",
	},
	{
		"<leader>fa",
		function()
			Snacks.picker.commands()
		end,
		desc = "Find commands",
	},
	{
		"<leader>fb",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Find buffers",
	},
	{
		"<leader>ff",
		function()
			Snacks.picker.files()
		end,
		desc = "Find files",
	},
	{
		"<leader>fg",
		function()
			Snacks.picker.grep()
		end,
		desc = "Find text",
	},
	{
		"<leader>fl",
		function()
			Snacks.picker.resume()
		end,
		desc = "Resume last search",
	},
	{
		"<leader>fp",
		function()
			Snacks.picker.git_files()
		end,
		desc = "Find git files",
	},
	{
		"<leader>fs",
		"<cmd>AerialToggle!<cr>",
		desc = "Symbols outline",
	},
	{
		"<leader>g",
		group = "Git",
	},
	{
		"<leader>gC",
		function()
			Snacks.picker.git_log_file()
		end,
		desc = "Checkout commit(for current file)",
	},
	{
		"<leader>gi",
		function()
			Snacks.picker.gh_issue()
		end,
		desc = "GitHub Issues (open)",
	},
	{
		"<leader>gI",
		function()
			Snacks.picker.gh_issue({ state = "all" })
		end,
		desc = "GitHub Issues (all)",
	},
	{
		"<leader>gP",
		function()
			Snacks.picker.gh_pr()
		end,
		desc = "GitHub Pull Requests (open)",
	},
	{
		"<leader>gA",
		function()
			Snacks.picker.gh_pr({ state = "all" })
		end,
		desc = "GitHub Pull Requests (all)",
	},
	{
		"<leader>gD",
		"<cmd>DiffviewOpen<cr>",
		desc = "Diff view open",
	},
	{
		"<leader>gH",
		"<cmd>DiffviewFileHistory<cr>",
		desc = "Diff file history",
	},
	{
		"<leader>gR",
		"<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
		desc = "Git reset Buffer",
	},
	{
		"<leader>gb",
		function()
			Snacks.picker.git_branches()
		end,
		desc = "Git checkout branch",
	},
	{
		"<leader>gc",
		function()
			Snacks.picker.git_log()
		end,
		desc = "Git checkout commit",
	},
	{
		"<leader>gd",
		"<cmd>Gitsigns diffthis HEAD<cr>",
		desc = "Git Diff",
	},
	{
		"<leader>gg",
		function()
			Snacks.lazygit()
		end,
		desc = "Lazygit",
	},
	{
		"<leader>gj",
		"<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>",
		desc = "Git next Hunk",
	},
	{
		"<leader>gk",
		"<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>",
		desc = "Git prev Hunk",
	},
	{
		"<leader>gl",
		"<cmd>lua require 'gitsigns'.blame_line()<cr>",
		desc = "Git blame",
	},
	{
		"<leader>go",
		function()
			Snacks.picker.git_status()
		end,
		desc = "Git open changed file",
	},
	{
		"<leader>gp",
		"<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
		desc = "Git preview Hunk",
	},
	{
		"<leader>gr",
		"<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
		desc = "Git reset Hunk",
	},
	{
		"<leader>h",
		group = "Harpoon",
	},
	{
		"<leader>ha",
		function()
			harpoon:list():add()
		end,
		desc = "Harpoon add mark",
	},
	{
		"<leader>he",
		function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end,
		desc = "Harpoon browse marks",
	},
	{
		"<leader>l",
		group = "LSP",
	},
	{
		"<leader>lD",
		function()
			Snacks.picker.diagnostics_buffer()
		end,
		desc = "Buffer Diagnostics",
	},
	{
		"<leader>lI",
		"<cmd>checkhealth vim.lsp<cr>",
		desc = "Info",
	},
	{
		"<leader>lQ",
		"<cmd>lua vim.diagnostic.setloclist()<cr>",
		desc = "Quickfix",
	},
	{
		"<leader>lR",
		"<cmd>lua vim.lsp.buf.rename()<cr>",
		desc = "Rename",
	},
	{
		"<leader>lS",
		function()
			Snacks.picker.lsp_workspace_symbols()
		end,
		desc = "Workspace Symbols",
	},
	{
		"<leader>lW",
		function()
			Snacks.picker.diagnostics()
		end,
		desc = "Diagnostics",
	},
	{
		"<leader>la",
		"<cmd>lua vim.lsp.buf.code_action()<cr>",
		desc = "Code Action",
	},
	{
		"<leader>ld",
		function()
			Snacks.picker.lsp_definitions()
		end,
		desc = "Definitions",
	},
	{
		"<leader>le",
		function()
			Snacks.picker.qflist()
		end,
		desc = "Quickfix list",
	},
	{
		"<leader>lf",
		"<cmd>lua vim.lsp.buf.format()<cr>",
		desc = "Format",
	},
	{
		"<leader>li",
		function()
			Snacks.picker.lsp_implementations()
		end,
		desc = "Implementations",
	},
	{
		"<leader>lj",
		"<cmd>lua vim.diagnostic.goto_next()<cr>",
		desc = "Next Diagnostic",
	},
	{
		"<leader>lk",
		"<cmd>lua vim.diagnostic.goto_prev()<cr>",
		desc = "Prev Diagnostic",
	},
	{
		"<leader>ll",
		"<cmd>lua vim.lsp.codelens.run()<cr>",
		desc = "CodeLens Action",
	},
	{
		"<leader>lq",
		"<cmd>lua vim.lsp.buf.signature_help()<cr>",
		desc = "Signature info",
	},
	{
		"<leader>lr",
		function()
			Snacks.picker.lsp_references()
		end,
		desc = "References",
	},
	{
		"<leader>ls",
		function()
			Snacks.picker.lsp_symbols()
		end,
		desc = "Document Symbols",
	},
	{
		"<leader>o",
		group = "Octo (PR Review)",
	},
	{
		"<leader>op",
		"<cmd>Octo pr list<cr>",
		desc = "List PRs",
	},
	{
		"<leader>oo",
		"<cmd>Octo pr search<cr>",
		desc = "Search PRs",
	},
	{
		"<leader>or",
		"<cmd>Octo review start<cr>",
		desc = "Start review",
	},
	{
		"<leader>oR",
		"<cmd>Octo review resume<cr>",
		desc = "Resume review",
	},
	{
		"<leader>oS",
		"<cmd>Octo review submit<cr>",
		desc = "Submit review",
	},
	{
		"<leader>oc",
		"<cmd>Octo review comments<cr>",
		desc = "Review comments",
	},
	{
		"<leader>oa",
		"<cmd>Octo review approve<cr>",
		desc = "Approve PR",
	},
	{
		"<leader>om",
		"<cmd>Octo pr merge<cr>",
		desc = "Merge PR",
	},
	{
		"<leader>oi",
		"<cmd>Octo issue list<cr>",
		desc = "List issues",
	},
	{
		"<leader>j",
		"<cmd>AerialNext<CR>",
		desc = "Next method/symbol",
	},
	{
		"<leader>k",
		"<cmd>AerialPrev<CR>",
		desc = "Prev method/symbol",
	},
	{
		"<leader>q",
		"<cmd>confirm q<CR>",
		desc = "Quit",
	},
	{
		"<leader>r",
		group = "Find and replace",
	},
	{
		"<leader>rf",
		function()
			require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })
		end,
		desc = "Find and replace in current file",
	},
	{
		"<leader>ro",
		function()
			require("grug-far").open()
		end,
		desc = "Find and replace - Open",
	},
	{
		"<leader>rw",
		function()
			require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
		end,
		desc = "Find and replace - Search current word",
	},
	{
		"<leader>s",
		"<cmd>lua require('utils.treesitter-utils').goto_translation()<CR>",
		desc = "Go to translation",
	},
	{
		"<leader>t",
		group = "Test",
	},
	{
		"<leader>tF",
		"<cmd>w<cr><cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
		desc = "Debug File",
	},
	{
		"<leader>tL",
		"<cmd>w<cr><cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>",
		desc = "Debug Last",
	},
	{
		"<leader>tN",
		"<cmd>w<cr><cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
		desc = "Debug Nearest",
	},
	{
		"<leader>tO",
		"<cmd>lua require('neotest').output.open({ enter = true })<cr>",
		desc = "Full Output",
	},
	{
		"<leader>tS",
		"<cmd>lua require('neotest').run.stop()<cr>",
		desc = "Stop",
	},
	{
		"<leader>ta",
		"<cmd>lua require('neotest').run.attach()<cr>",
		desc = "Attach",
	},
	{
		"<leader>tf",
		"<cmd>w<cr><cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
		desc = "Run File",
	},
	{
		"<leader>tl",
		"<cmd>w<cr><cmd>lua require('neotest').run.run_last()<cr>",
		desc = "Run Last",
	},
	{
		"<leader>tn",
		"<cmd>w<cr><cmd>lua require('neotest').run.run()<cr>",
		desc = "Run Nearest",
	},
	{
		"<leader>to",
		"<cmd>lua require('neotest').output.open({ enter = true, short = true })<cr>",
		desc = "Short output",
	},
	{
		"<leader>ts",
		"<cmd>lua require('neotest').summary.toggle()<cr>",
		desc = "Summary",
	},
	{
		"<leader>u",
		"<cmd>UndotreeToggle<CR>",
		desc = "Undotree",
	},
	{
		"<leader>w",
		"<cmd>w!<CR>",
		desc = "Save",
	},
	{
		"<leader>x",
		group = "Trouble",
	},
	{
		"<leader>xx",
		"<cmd>Trouble diagnostics toggle<cr>",
		desc = "Diagnostics (workspace)",
	},
	{
		"<leader>xb",
		"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
		desc = "Buffer Diagnostics",
	},
	{
		"<leader>xq",
		"<cmd>Trouble qflist toggle<cr>",
		desc = "Quickfix List",
	},
	{
		"<leader>xl",
		"<cmd>Trouble loclist toggle<cr>",
		desc = "Location List",
	},
	{
		"<leader>xs",
		"<cmd>Trouble symbols toggle<cr>",
		desc = "Document Symbols",
	},
}

which_key.setup({
	plugins = {
		marks = false,
		registers = false,
		spelling = {
			enabled = true,
			suggestions = 20,
		},
		presets = {
			operators = false,
			motions = false,
			text_objects = false,
			windows = false,
			nav = false,
			z = false,
			g = false,
		},
	},
	win = {
		border = "single",
		padding = { 2, 2 },
	},
	layout = {
		spacing = 3,
		align = "left",
	},
	show_help = true,
	show_keys = true,
	disable = {
		buftypes = {},
		filetypes = { "TelescopePrompt" },
	},
})

which_key.add(mappings)
which_key.add(vmappings)
