local setup, plugin = pcall(require, "nvim-ts-autotag")
if not setup then
	return
end

plugin.setup({
	opts = {
		-- Defaults
		enable_close_on_slash = true,
	},
})

local autotag_group = vim.api.nvim_create_augroup("autotag_group_custom", {})

-- rename tags on paste also
vim.api.nvim_create_autocmd({ "User" }, {
	group = autotag_group,
	pattern = { "PastePost" },
	callback = function()
		if require("nvim-ts-autotag.config.plugin").get_opts(vim.bo.filetype).enable_rename then
			require("nvim-ts-autotag.internal").rename_tag()
		end
	end,
})
