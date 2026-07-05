local setup, plugin = pcall(require, "dressing")
if not setup then
	return
end

plugin.setup({
	input = {
		winhighlight = "NormalFloat:DiagnosticError",
	},
})
