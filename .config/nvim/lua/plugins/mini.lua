return {
	{
		"echasnovski/mini.surround",
		version = false,
		opts = {},
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
		opts = {
			options = {
				use_as_default_explorer = false,
			},
		},
		config = function(ctx)
			require("mini.files").setup(ctx.opts)
		end,
	},
}
