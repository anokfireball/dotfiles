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

	-- GitHub Copilot
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			panel = {
				enabled = false,
			},
			suggestion = {
				enabled = not vim.g.ai_cmp,
				auto_trigger = true,
				hide_during_completion = vim.g.ai_cmp,
				keymap = {
					accept = false,
					accept_word = "<S-Right>",
					next = "<C-n>",
					prev = "<C-p>",
				},
			},
		},
	},

	-- AI coding assistant
	{
		"olimorris/codecompanion.nvim",
		cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat" },
		keys = {
			{ "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "[C]odeCompanion [A]ctions" },
			{ "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "[C]odeCompanion [C]hat" },
			{
				"<leader>ce",
				"<cmd>CodeCompanion /explain<cr>",
				mode = { "n", "v" },
				desc = "[C]odeCompanion [E]xplain",
			},
			{ "<leader>cf", "<cmd>CodeCompanion /fix<cr>", mode = { "n", "v" }, desc = "[C]odeCompanion [F]ix" },
			{
				"<leader>cv",
				"<cmd>CodeCompanion /commit<cr>",
				mode = { "n", "v" },
				desc = "[C]odeCompanion [V]CS Commit Message",
			},
			{ "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to CodeCompanion" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"zbirenbaum/copilot.lua",
			"MeanderingProgrammer/render-markdown.nvim",
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
