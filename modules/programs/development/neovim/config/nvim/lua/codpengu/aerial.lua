local setup, plugin = pcall(require, "aerial")
if not setup then
	return
end

plugin.setup({
	manage_folds = true,
	show_guides = true,
	layout = {
		min_width = 45,
		default_direction = "right",
		manage_folds = true,
		link_folds_to_tree = false,
		win_opts = {
			number = true,
			relativenumber = true,
		},
	},
})
