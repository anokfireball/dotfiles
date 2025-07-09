return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	lazy = false,
	opts = {
		enable_diagnostics = false,
		enable_cursor_hijack = true,
		popup_border_style = "",
		default_component_configs = {
			name = {
				trailing_slash = true,
				highlight_opened_files = false,
			},
			git_status = {
				symbols = {
					-- Change type
					added = "+",
					deleted = "-",
					modified = "~",
					renamed = "»",
					-- Status type
					untracked = "?",
					ignored = "x",
					unstaged = "○",
					staged = "●",
					conflict = "!",
				},
			},
		},
		window = {
			position = "right",
		},
		-- TOOD key mappings in window, filesyste, buffers, git_status, document_symbols, example
	},
}
