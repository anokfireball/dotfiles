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
		delay = 1000,
		spec = {
			{ "<leader>", group = "leader" },
			{ "<leader>c", mode = { "n", "v" }, group = "[C]odeCompanion" },
			{ "<leader>f", group = "[F]ind" },
			{ "<leader>t", group = "[T]oggle" },
			{ "<leader>v", group = "[V]CS" },

			{ "gs", mode = { "n", "v" }, group = "[S]urround" },
			{ "gsa", mode = { "n", "v" }, group = "[S]urround [A]dd" },
			{ "gsd", mode = { "n", "v" }, group = "[S]urround [D]elete" },
			{ "gsf", mode = { "n", "v" }, group = "[S]urround [F]ind" },
			{ "gsF", mode = { "n", "v" }, group = "[S]urround [F]ind Left" },
			{ "gsh", mode = { "n", "v" }, group = "[S]urround [H]ighlight" },
			{ "gsr", mode = { "n", "v" }, group = "[S]urround [R]eplace" },
		},
		plugins = {
			spelling = { enabled = false },
		},
		win = {
			title = false,
		},
		show_help = false,
		show_keys = false,
	},
}
