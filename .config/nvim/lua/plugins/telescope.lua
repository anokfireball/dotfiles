return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-tree/nvim-web-devicons" },
		-- extensions
		-- { "nvim-telescope/telescope-frecency.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				-- frecency = {
				-- 	matcher = "fuzzy",
				--                 default_workspace = "CWD",
				-- 	workspaces = {
				--                     NVIM = vim.fn.stdpath("config"),
				-- 	},
				-- },
				fzf = {},
				["ui-select"] = {},
			},
		})
		-- require("telescope").load_extension("frecency")
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")
	end,
}
