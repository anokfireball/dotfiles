return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	opts = {
		scope = {
			show_start = false,
			show_end = false,
			char = "|",
		},
		indent = {
			char = "|",
			tab_char = nil,
		},
	},
	config = function(ctx)
		require("ibl").setup(ctx.opts)
	end,
}
