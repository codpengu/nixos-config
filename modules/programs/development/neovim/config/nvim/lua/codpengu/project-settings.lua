-- lua/project_settings.lua
local M = {}

-- Function to load project configuration
function M.load_project_config()
	local config_path = vim.fn.getcwd() .. "/.nvim.lua"
	if vim.fn.filereadable(config_path) == 1 then
		local config = dofile(config_path)
		return config
	end
	return {}
end

-- Function to apply language specific settings
function M.apply_language_settings()
	local config = M.load_project_config()

	-- Get language settings from config
	local lang_settings = config.language_settings or {}

	-- Create autocmd group for project settings
	local group = vim.api.nvim_create_augroup("ProjectLocalSettings", { clear = true })

	-- For each language in the config
	for lang, settings in pairs(lang_settings) do
		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = lang,
			callback = function()
				-- Apply indent settings
				if settings.indent then
					if settings.indent.tabstop then
						vim.bo.tabstop = settings.indent.tabstop
					end
					if settings.indent.shiftwidth then
						vim.bo.shiftwidth = settings.indent.shiftwidth
					end
					if settings.indent.expandtab ~= nil then
						vim.bo.expandtab = settings.indent.expandtab
					end
					if settings.indent.softtabstop then
						vim.bo.softtabstop = settings.indent.softtabstop
					end
				end

				-- Apply any additional buffer-local options
				if settings.options then
					for option, value in pairs(settings.options) do
						vim.bo[option] = value
					end
				end

				-- Apply any window-local options
				if settings.window_options then
					for option, value in pairs(settings.window_options) do
						vim.wo[option] = value
					end
				end

				-- Apply any global options that should be set for this filetype
				if settings.global_options then
					for option, value in pairs(settings.global_options) do
						vim.go[option] = value
					end
				end
			end,
		})
	end
end

-- Function to get a specific setting for the current project
function M.get_project_setting(setting_path)
	local config = M.load_project_config()
	local current_table = config

	for key in string.gmatch(setting_path, "[^%.]+") do
		if type(current_table) ~= "table" then
			return nil
		end
		current_table = current_table[key]
	end

	return current_table
end

-- Create an autocommand to apply settings when entering a new directory
local dir_group = vim.api.nvim_create_augroup("ProjectSettingsDirChange", { clear = true })
vim.api.nvim_create_autocmd({ "DirChanged" }, {
	group = dir_group,
	callback = function()
		M.apply_language_settings()
	end,
})

-- Initialize settings immediately for the current directory
M.apply_language_settings()

return M
