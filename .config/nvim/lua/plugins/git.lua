return {
	-- Git signs in the gutter
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			current_line_blame = true,
			current_line_blame_opts = {
				delay = 750,
			},
			current_line_blame_formatter = "  <author>, <author_time:%R> - <summary>",
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = GitSignsOnAttach,
			worktrees = {
				{
					toplevel = vim.env.HOME,
					gitdir = vim.env.HOME .. "/.dotfiles.git",
				},
			},
		},
	},

	-- Git diff view
	{
		"sindrets/diffview.nvim",
		cmd = "DiffviewOpen",
	},

	-- Create shareable permalinks to code locations
	{
		"trevorhauter/gitportal.nvim",
		cmd = "GitPortal",
		opts = {
			always_include_current_line = true,
			switch_branch_or_commit_upon_ingestion = "ask",
		},
	},
}
