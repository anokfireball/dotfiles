return {
	-- PCRE Regexes
	{
		"othree/eregex.vim",
		event = "CmdlineEnter",
	},

	-- Auto-pairs
	{
		"echasnovski/mini.pairs",
		version = false,
		event = "InsertEnter",
		config = function(ctx)
			require("mini.pairs").setup(ctx.opts)
		end,
	},

	-- Split/join code blocks
	{
		"echasnovski/mini.splitjoin",
		version = false,
		event = "BufReadPre",
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

	-- Surround text objects
	{
		"echasnovski/mini.surround",
		version = false,
		event = "BufReadPre",
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

	-- AI coding assistant
	{
		"olimorris/codecompanion.nvim",
		event = "VeryLazy",
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
	},
}
