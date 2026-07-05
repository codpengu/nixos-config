local setup, plugin = pcall(require, "ibl")
if not setup then
	return
end

plugin.setup({
    indent = {
        char = "┊",
    },
    whitespace = {
        remove_blankline_trail = false,
    },
    scope = {
        enabled = true,
    },
})
