local setup, plugin = pcall(require, "refactoring")
if not setup then
	return
end

plugin.setup({})
