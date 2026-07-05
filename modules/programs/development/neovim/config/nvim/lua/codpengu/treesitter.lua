local setup, plugin = pcall(require, "nvim-treesitter.configs")
if not setup then
	return
end

plugin.setup({
	highlight = {
		enable = true,
	},
})

