return {
	{
		"echasnovski/mini.surround",
		version = false,
		opts = {
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
				update_n_lines = "",
				suffix_last = "",
				suffix_next = "",
			},
		},
		config = function(ctx)
			require("mini.surround").setup(ctx.opts)
		end,
	},
	{
		"echasnovski/mini.statusline",
		version = false,
		opts = { use_icons = vim.g.have_nerd_font },
		config = function(ctx)
			local statusline = require("mini.statusline")
			statusline.setup(ctx.opts)
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},
	{
		"echasnovski/mini.files",
		version = false,
		config = function(ctx)
			require("mini.files").setup(ctx.opts)
		end,
	},
	{
		"echasnovski/mini.cursorword",
		version = false,
		config = function(ctx)
			require("mini.cursorword").setup(ctx.opts)
			vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {})
		end,
	},
	{
		"echasnovski/mini.pairs",
		version = false,
		config = function(ctx)
			require("mini.pairs").setup(ctx.opts)
		end,
	},
	{
		"echasnovski/mini.splitjoin",
		version = false,
		opts = {
			mappings = {
				toggle = "",
				split = "gS",
				join = "gJ",
			},
		},
		config = function(ctx)
			require("mini.splitjoin").setup(ctx.opts)
		end,
	},
	{
		"echasnovski/mini.indentscope",
		version = false,
		opts = {
			draw = {
				delay = 100,
				animation = function()
					return 0
				end,
			},
			options = {
				try_as_border = true,
			},
			symbol = "┊",
		},
		config = function(ctx)
			require("mini.indentscope").setup(ctx.opts)
		end,
	},
}
