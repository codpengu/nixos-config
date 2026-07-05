local setup, cmp = pcall(require, "cmp")
if not setup then
	return
end

local compare = require("cmp.config.compare")
local luasnip = require("luasnip")

-- Load VSCode-style snippets from friendly-snippets
require("luasnip.loaders.from_vscode").lazy_load()

local has_words_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

vim.opt.pumheight = 8

cmp.setup({
	experimental = {
		ghost_text = true,
	},
	completion = {
		autocomplete = {
			cmp.TriggerEvent.TextChanged,
		},
		keyword_length = 3,
	},
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	sorting = {
		priority_weight = 1,
		comparators = {
			compare.exact,
			compare.locality,
			compare.sort_text,
			compare.recently_used,
			compare.kind,
			compare.length,
			compare.order,
		},
	},

	mapping = {
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),

		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-y>"] = cmp.config.disable,
		["<C-e>"] = cmp.mapping({
			i = cmp.mapping.abort(),
			c = cmp.mapping.close(),
		}),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = cmp.config.sources({
		{ name = "nvim_lsp",                priority = 10,     max_item_count = 15 },
		{ name = "nvim_lsp_signature_help", max_item_count = 15 },
		{ name = "luasnip" },
		{ name = "calc" },
		{ name = "path",                    priority = 1 },
		{ name = "buffer",                  priority = 0,      max_item_count = 5 },
	}),
})

-- Use buffer source for `/`
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
	},
})

vim.o.completeopt = "menuone,noselect"
