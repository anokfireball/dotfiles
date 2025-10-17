return {
	-- SOPS file encryption/decryption
	{
		"anokfireball/sops-edit.nvim",
		ft = { "yaml", "json", "dosini", "sh" },
		opts = {
			verbose = false,
		},
	},

	-- Clipboard manager
	{
		"AckslD/nvim-neoclip.lua",
		dependencies = { "nvim-telescope/telescope.nvim" },
		cmd = { "Telescope neoclip" },
		keys = {
			{ "<leader>fc", "<cmd>Telescope neoclip<cr>", desc = "[F]ind in [C]lipboard History" },
		},
		config = function(ctx)
			require("neoclip").setup(ctx.opts)
		end,
	},

	-- Auto-pairs
	{
		"echasnovski/mini.pairs",
		version = false,
		event = "InsertEnter",
		opts = {
			mappings = {
				["("] = { action = "open", pair = "()", neigh_pattern = "[^\\][%p%s]" },
				["["] = { action = "open", pair = "[]", neigh_pattern = "[^\\][%p%s]" },
				["{"] = { action = "open", pair = "{}", neigh_pattern = "[^\\][%p%s]" },

				['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\][%p%s]", register = { cr = false } },
				["'"] = {
					action = "closeopen",
					pair = "''",
					neigh_pattern = "[^%a\\][%p%s]",
					register = { cr = false },
				},
				["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\][%p%s]", register = { cr = false } },
			},
		},
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
		"sudo-tee/opencode.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
			"saghen/blink.cmp",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			preferred_picker = "telescope",
			preferred_completion = "blink",
			ui = {
				icons = {
					preset = "text",
				},
			},
		},
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
}
