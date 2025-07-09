return {
	"folke/which-key.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = "VeryLazy",
	config = function(ctx)
		require("which-key").setup(ctx.opts)
		vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "Normal" })
		vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "Normal" })
	end,
	opts = {
		preset = "helix",
		delay = 1500,
		spec = {
			{ "<leader>", group = "leader" },
			{ "<leder>e", group = "[E]xplorer" },
			{ "<leader>f", group = "[F]ind" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>v", group = "[V]CS" },
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
