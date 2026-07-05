local setup, plugin = pcall(require, "telescope")
if not setup then
	return
end

plugin.setup({
	defaults = {
		path_display = { "filename_first" },
	},
	pickers = {
		buffers = {
			show_all_buffers = true,
			sort_mru = true,
			mappings = {
				i = {
					["<c-d>"] = "delete_buffer",
				},
			},
		},
	},
	fzf = {
		fuzzy = true,
		override_generic_sorter = true,
		override_file_sorter = true,
		case_mode = "smart_case",
	},
})

require("telescope").load_extension("fzf")
