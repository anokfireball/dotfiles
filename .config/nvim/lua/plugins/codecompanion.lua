return {
	"olimorris/codecompanion.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"github/copilot.vim", -- run ":Copilot setup" to get the required token
	},
	opts = {
		strategies = {
			chat = {
				adapter = "copilot",
			},
			inline = {
				adapter = "copilot",
			},
			cmd = {
				adapter = "copilot",
			},
		},
	},
}
