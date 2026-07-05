local setup, plugin = pcall(require, "symbols-outline")
if not setup then
	return
end

plugin.setup()
