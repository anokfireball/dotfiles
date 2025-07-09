return {
	"lewis6991/gitsigns.nvim",
	opts = {
		current_line_blame = true,
		current_line_blame_opts = {
			delay = 750,
		},
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = GitSignsOnAttach,
	},
}
