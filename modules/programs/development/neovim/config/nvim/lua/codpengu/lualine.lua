local setup, plugin = pcall(require, "lualine")
if not setup then
	return
end

plugin.setup({
	options = {
		theme = "carbonfox",
	},
})
