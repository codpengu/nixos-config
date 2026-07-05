local setup, plugin = pcall(require, "nvim-surround")
if not setup then
	return
end

plugin.setup()
