return {
	"folke/which-key.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	config = function(ctx)
		require("which-key").setup(ctx.opts)
		vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "Normal" })
		vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "Normal" })
	end,
	opts = {
		preset = "helix",
		delay = 1000,
		spec = {
			{ "<leader>", group = "leader" },
			{ "<leader>f", group = "[f]ind" },
		},
		plugins = {
			spelling = { enabled = false },
		},
		win = {
			title = false,
			padding = { 1, 2 },
			wo = { winblend = 0 },
		},
	},
}
