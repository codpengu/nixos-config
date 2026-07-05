local setup, octo = pcall(require, "octo")
if not setup then
	return
end

octo.setup({
	use_local_fs = false,
	picker = "snacks",
	picker_config = {
		use_emojis = true,
	},
	ui = {
		use_signcolumn = true,
	},
	file_panel = {
		size = 10,
		icons = true,
	},
	reviews = {
		auto_show_threads = true,
	},
	mappings = {
		review_diff = {
			add_review_comment = { lhs = "<leader>oc", desc = "Add review comment" },
			add_review_suggestion = { lhs = "<leader>os", desc = "Add review suggestion" },
			focus_files = { lhs = "<leader>of", desc = "Move focus to changed files panel" },
			toggle_files = { lhs = "<leader>ob", desc = "Toggle changed files panel" },
			next_thread = { lhs = "]t", desc = "Move to next thread" },
			prev_thread = { lhs = "[t", desc = "Move to prev thread" },
			select_next_entry = { lhs = "]q", desc = "Move to next file" },
			select_prev_entry = { lhs = "[q", desc = "Move to previous file" },
			close_review_tab = { lhs = "<leader>oq", desc = "Close review tab" },
			toggle_viewed = { lhs = "<leader>ov", desc = "Toggle file as viewed" },
		},
		review_thread = {
			add_comment = { lhs = "<leader>oc", desc = "Add comment" },
			add_suggestion = { lhs = "<leader>os", desc = "Add suggestion" },
			delete_comment = { lhs = "<leader>od", desc = "Delete comment" },
			next_comment = { lhs = "]c", desc = "Go to next comment" },
			prev_comment = { lhs = "[c", desc = "Go to previous comment" },
			select_next_entry = { lhs = "]q", desc = "Move to next file" },
			select_prev_entry = { lhs = "[q", desc = "Move to previous file" },
			close_review_tab = { lhs = "<leader>oq", desc = "Close review tab" },
			react_hooray = { lhs = "<leader>oo", desc = "Add hooray reaction" },
			react_heart = { lhs = "<leader>oh", desc = "Add heart reaction" },
			react_thumbs_up = { lhs = "<leader>o+", desc = "Add thumbs up reaction" },
			react_thumbs_down = { lhs = "<leader>o-", desc = "Add thumbs down reaction" },
			react_rocket = { lhs = "<leader>or", desc = "Add rocket reaction" },
		},
		submit_win = {
			approve_review = { lhs = "<C-a>", desc = "Approve review" },
			comment_review = { lhs = "<C-m>", desc = "Comment review" },
			request_changes = { lhs = "<C-r>", desc = "Request changes" },
			close_review_tab = { lhs = "<C-q>", desc = "Close review tab" },
		},
	},
})
