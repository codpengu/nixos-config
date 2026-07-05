local setup, harpoon = pcall(require, "harpoon")
if not setup then
	return
end

-- REQUIRED
harpoon:setup({
	settings = {
		save_on_toggle = true,
		sync_on_ui_close = true,
		key = function()
			return vim.loop.cwd()
		end,
	},
})
-- REQUIRED

vim.keymap.set("n", "<A-h>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<A-j>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<A-k>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<A-l>", function()
	harpoon:list():select(4)
end)
