local setup, rest_nvim = pcall(require, "rest-nvim")
if not setup then
	return
end

local autocmd = vim.api.nvim_create_autocmd

rest_nvim.setup({
	-- Open request results in a horizontal split
	-- Skip SSL verification, useful for unknown certificates
	skip_ssl_verification = false,
	-- Highlight request on run
	highlight = {
		enable = true,
		timeout = 150,
	},
	result = {
		split = {
			in_place = false,
			horizontal = false,
		},
		-- toggle showing URL, HTTP info, headers at top the of result window
		behavior = {
			show_info = {
				url = true,
				http_info = true,
				headers = true,
			},
		},
	},
	-- Jump to request line on run
	-- jump_to_request = false,
	custom_dynamic_variables = {},
	env_file = ".env",
})

vim.filetype.add({ extension = { http = "http" } })

autocmd("FileType", {
	pattern = { "http", "text", "*" },
	callback = http_mappings,
	desc = "HTTP Buffer mappings",
})
