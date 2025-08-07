return {
	-- Colorscheme
	{
		"dracula/vim",
		name = "dracula",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("dracula")
		end,
	},

	-- Highlight word under cursor
	{
		"echasnovski/mini.cursorword",
		version = false,
		event = "BufReadPre",
		config = function(ctx)
			require("mini.cursorword").setup(ctx.opts)
			vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", {})
		end,
	},

	-- Indent visualization
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = "BufReadPre",
		opts = {
			draw = {
				delay = 100,
				animation = function()
					return 0
				end,
			},
			options = {
				try_as_border = true,
			},
			symbol = "┊",
		},
		config = function(ctx)
			require("mini.indentscope").setup(ctx.opts)
		end,
	},

	-- Status line
	{
		"echasnovski/mini.statusline",
		version = false,
		event = "VimEnter",
		opts = { use_icons = vim.g.have_nerd_font },
		config = function(ctx)
			local statusline = require("mini.statusline")
			statusline.setup(ctx.opts)
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	-- Comment highlighting
	{
		"folke/todo-comments.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},

	-- Keybinding display
	{
		"folke/which-key.nvim",
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
	},

	-- Notifications
	{
		"rcarriga/nvim-notify",
		event = "VimEnter",
		opts = {
			fps = 144,
			minimum_width = 1,
			render = "wrapped-compact",
			stages = "fade",
			timeout = 5000,
			top_down = true,
		},
		config = function(ctx)
			require("notify").setup(ctx.opts)
			vim.notify = require("notify")
		end,
	},

	-- Dim inactive windows
	{
		"tadaa/vimade",
		event = "VimEnter",
		opts = {
			recipe = { "default", { animate = true } },
			ncmode = "windows",
			fadelevel = 0.5,
		},
	},
}

