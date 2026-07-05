local setup, plugin = pcall(require, "colorizer")
if not setup then
	return
end

plugin.setup()
