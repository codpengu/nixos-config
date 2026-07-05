local setup, plugin = pcall(require, "gitsigns")
if not setup then
	return
end

plugin.setup()
