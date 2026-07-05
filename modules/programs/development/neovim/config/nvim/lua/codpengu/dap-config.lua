local setup_dap, dap = pcall(require, "dap")
if not setup_dap then
	return
end

local setup_dapui, dapui = pcall(require, "dapui")
if not setup_dapui then
	return
end

require("nvim-dap-virtual-text").setup()
dapui.setup()
require("telescope").load_extension("dap")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
