local setup, plugin = pcall(require, "typescript-tools")
if not setup then
	return
end

plugin.setup({
	settings = {
		tsserver_file_preferences = {
			importModuleSpecifierPreference = "non-relative",
		},
	},
	on_attach = function(client, bufnr)
		local opts = { buffer = bufnr }
		vim.keymap.set("n", "<leader>ir", "<cmd>TSToolsRenameFile<CR>", vim.tbl_extend("force", opts, { desc = "Rename file" }))
		vim.keymap.set("n", "<leader>ia", "<cmd>TSToolsAddMissingImports sync<CR>", vim.tbl_extend("force", opts, { desc = "Add missing imports" }))
		vim.keymap.set("n", "<leader>io", "<cmd>TSToolsOrganizeImports sync<CR>", vim.tbl_extend("force", opts, { desc = "Organize imports" }))
		vim.keymap.set("n", "<leader>iu", "<cmd>TSToolsRemoveUnusedImports sync<CR>", vim.tbl_extend("force", opts, { desc = "Remove unused imports" }))
		vim.keymap.set("n", "<leader>if", "<cmd>TSToolsFixAll sync<CR>", vim.tbl_extend("force", opts, { desc = "Fix all" }))
	end,
})
