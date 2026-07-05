local bind = vim.api.nvim_set_keymap

local opt = { noremap = false, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = ";"

-- Better navigation
bind("n", "<C-h>", "<C-w>h", opt)
bind("n", "<C-l>", "<C-w>l", opt)
bind("n", "<C-j>", "<C-w>j", opt)
bind("n", "<C-k>", "<C-w>k", opt)

-- jump 10 lines when holding shift
bind("n", "<s-j>", "10j", opt)
bind("n", "<s-k>", "10k", opt)
bind("v", "<s-j>", "10j", opt)
bind("v", "<s-k>", "10k", opt)

-- escape by jk
bind("i", "jk", "<ESC>", { noremap = false, silent = true })
bind("t", "jk", "<C-\\><C-n>", { noremap = false, silent = true })

-- TODO: Move these to which-key soonTM
-- show the error message when hovering
bind("n", "<a-q>", "<cmd>lua vim.diagnostic.open_float({focusable = false, show_header = false})<cr>", opt)
-- code actions
bind("n", "<a-cr>", "<cmd>lua vim.lsp.buf.code_action()<cr>", {})
bind("v", "<a-cr>", "<cmd>lua vim.lsp.buf.code_action()<cr>", {})
bind("i", "<a-q>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {})

-- goto jumps
bind("n", "<a-i>", "<cmd>lua Snacks.picker.lsp_implementations()<cr>", opt)
bind("n", "<a-d>", "<cmd>lua Snacks.picker.lsp_definitions()<cr>", opt)
bind("n", "<a-r>", "<cmd>lua Snacks.picker.lsp_references()<cr>", opt)
bind("n", "<a-c>", "<cmd>lua Snacks.picker.lsp_workspace_symbols()<cr>", opt)

-- diagnostics
bind("n", "<a-[>", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opt)
bind("n", "<a-]>", "<cmd>lua vim.diagnostic.goto_next()<cr>", opt)
