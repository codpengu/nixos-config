local setup, plugin = pcall(require, "auto-session")
if not setup then
	return
end

-- Root directories to scan recursively when running :SyncProjectSessions
local project_dirs = { "~/Documents/dev" }

-- Guards against saving a blank state over a real session on startup.
-- Set to true only after the first session has been fully restored.
local session_loaded = false

-- folds removed: most expensive part of :mksession
-- buffers removed: restoring all open buffers is slow and triggers LSP on each
vim.opt.sessionoptions = "curdir,tabpages,winsize,winpos,terminal,localoptions"

plugin.setup({
	-- Match git projects at any depth under Documents/dev
	allowed_dirs = {
		"~/Documents/dev/**",
	},

	-- Disable auto-save: we handle saving manually in VimLeavePre below,
	-- which lets us force-stop LSP first (avoids waiting for graceful LSP shutdown).
	-- Also prevents the session picker from triggering a save before restoring.
	auto_save = false,

	cwd_change_handling = false,
	close_unsupported_windows = false,

	-- After restoring a session, point nvim-tree at the new project root
	-- and mark that a session is now active
	post_restore_cmds = {
		function()
			session_loaded = true
			local ok, api = pcall(require, "nvim-tree.api")
			if ok then
				api.tree.change_root(vim.fn.getcwd())
				api.tree.reload()
			end
		end,
	},

	-- Before restoring a session: save the current one only if a session was
	-- already loaded (skip on startup to avoid overwriting with blank state)
	pre_restore_cmds = {
		function()
			if not session_loaded then
				return
			end
			local ok, api = pcall(require, "nvim-tree.api")
			if ok then
				api.tree.close()
			end
			plugin.save_session()
			for _, client in ipairs(vim.lsp.get_clients()) do
				vim.lsp.stop_client(client.id, true)
			end
		end,
	},

	session_lens = {
		picker = "snacks",
		previewer = "summary",
		picker_opts = {
			preset = "telescope",
		},
	},
})

-- Save session on quit: force-stop LSP first so Neovim doesn't wait for
-- graceful server shutdown, then close nvim-tree, then write the session.
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		for _, client in ipairs(vim.lsp.get_clients()) do
			vim.lsp.stop_client(client.id, true)
		end
		local ok, api = pcall(require, "nvim-tree.api")
		if ok then
			api.tree.close()
		end
		plugin.save_session()
	end,
})

-- Recursively scan project_dirs for git repos (up to 5 levels deep) and create
-- a session entry for any not yet known to auto-session.
-- Run with :SyncProjectSessions to populate the picker after cloning new repos.
vim.api.nvim_create_user_command("SyncProjectSessions", function()
	local saved_cwd = vim.uv.cwd()
	local created = 0

	for _, dir in ipairs(project_dirs) do
		local expanded = vim.fn.expand(dir)
		local cmd = "fd -H -t d -d 5"
			.. " -E node_modules -E .gradle -E .idea -E build -E dist -E target -E .direnv -E .cache -E __pycache__ -E .next"
			.. " '^[.]git$' "
			.. vim.fn.shellescape(expanded)
			.. " 2>/dev/null"
		local git_dirs = vim.fn.systemlist(cmd)

		for _, git_dir in ipairs(git_dirs) do
			local project_path = git_dir:gsub("/?%.git/?$", "")
			local encoded = (project_path .. "/"):gsub("/", "%%")
			local session_file = vim.fn.stdpath("data") .. "/sessions/" .. encoded .. ".vim"

			if vim.fn.filereadable(session_file) == 0 then
				vim.cmd("noautocmd cd " .. vim.fn.fnameescape(project_path))
				plugin.save_session()
				created = created + 1
			end
		end
	end

	vim.cmd("noautocmd cd " .. vim.fn.fnameescape(saved_cwd))
	vim.notify(("SyncProjectSessions: registered %d new projects"):format(created), vim.log.levels.INFO)
end, { desc = "Recursively scan project dirs and register git repos as auto-session entries" })
