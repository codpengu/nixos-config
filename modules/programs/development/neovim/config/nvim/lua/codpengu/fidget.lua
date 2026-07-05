local setup, plugin = pcall(require, "fidget")
if not setup then
	return
end

plugin.setup()
