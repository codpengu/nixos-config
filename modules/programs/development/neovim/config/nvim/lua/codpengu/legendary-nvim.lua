local setup, plugin = pcall(require, "legendary")
if not setup then
	return
end

plugin.setup({
    extensions = {
        which_key = { auto_register = true },
    }
})
