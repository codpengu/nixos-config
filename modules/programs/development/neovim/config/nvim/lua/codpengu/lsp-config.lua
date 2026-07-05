-- Codeium AI completion (optional)
local presentCodeium, codeium = pcall(require, "codeium")
if presentCodeium then
	local codeium_lsp_dir = os.getenv("CODEIUM_LSP_DIR")
	codeium.setup({
		tools = {
			language_server = codeium_lsp_dir .. "/bin/codeium-lsp",
		},
	})
end

-- Set capabilities globally for ALL servers before enabling them
vim.lsp.config("*", {
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Enable servers — nvim-lspconfig provides their default configs via lsp/
vim.lsp.enable({
	"lua_ls",
	"kotlin_lsp",
	"rust_analyzer",
	"bashls",
	"svelte",
	"nixd",
	"dockerls",
	"docker_compose_language_service",
})

-- JDTLS (Java) — handled by nvim-jdtls, not the native LSP API
local function jdt_on_attach(client, bufnr)
	local jdtls = require("jdtls")
	vim.keymap.set("n", "<c-a-v>", "<cmd>lua require('jdtls').extract_variable()<cr>", { buffer = bufnr })
	vim.keymap.set("n", "<c-a-m>", "<cmd>lua require('jdtls').extract_method()<cr>", { buffer = bufnr })
	jdtls.setup_dap({ hotcodereplace = "auto" })
	require("jdtls.setup").add_commands()
	require("jdtls.dap").setup_dap_main_class_configs()
end

local home = os.getenv("HOME")

local function start_jdtls()
	local settings = {
		["java.settings.url"] = home .. "/.config/nvim/formatters/settings.prefs",
		["java.format.settings.profile"] = "Helix",
		["java.format.settings.url"] = home .. "/.config/nvim/formatters/eclipse-java-google-style.xml",

		java = {
			signatureHelp = { enabled = true },
			referenceCodeLens = { enabled = false },
			implementationsCodeLens = { enabled = false },
			autobuild = { enabled = true },
			trace = { server = "off" },
			contentProvider = { preferred = "fernflower" },
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
				},
			},
			project = {
				exclusions = { "**/generated/src/**" },
			},
		},
	}

	local lspconfig_util = require("lspconfig.util")
	local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	local root_dir = lspconfig_util.root_pattern(".git", "gradlew", "mvnw")(bufname)
	local workspace_dir = home .. "/.cache/jdtls_workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

	local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
	extendedClientCapabilities["progressReportProvider"] = false
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

	local java_debug_jar = os.getenv("JAVA_DEBUG_DIR")
	local java_test_jar = os.getenv("JAVA_TEST_DIR")
	local bundles = {
		vim.fn.glob(java_debug_jar, 1),
	}
	vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_jar), "\n"))

	require("jdtls").start_or_attach({
		cmd = { "jdt-ls", "--jvm-arg=-Xmx8g", "-data", workspace_dir },
		on_attach = jdt_on_attach,
		root_dir = root_dir,
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		settings = settings,
		init_options = {
			bundles = bundles,
			extendedCapabilities = extendedClientCapabilities,
			languageFeatures = {
				codeLens = false,
			},
		},
	})
end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "java",
	callback = start_jdtls,
	group = vim.api.nvim_create_augroup("LspCustom", { clear = true }),
})
