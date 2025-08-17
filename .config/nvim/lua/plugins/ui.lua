return {
	-- Colorscheme
	{
		"dracula/vim",
		name = "dracula",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("dracula")

			local heading_colors = {
				"#FF79C6",
				"#BD93F9",
				"#8BE9FD",
				"#50FA7B",
				"#FFB86C",
				"#F1FA8C",
			}

			for i, color in ipairs(heading_colors) do
				vim.api.nvim_set_hl(0, "RenderMarkdownH" .. i, { fg = color, bold = true })
				vim.api.nvim_set_hl(0, "markdownH" .. i, { fg = color, bold = true })
				vim.api.nvim_set_hl(0, "@markup.heading." .. i .. ".markdown", { fg = color, bold = true })
			end

			vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { bg = "#4A2F3A" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#3A2F4A" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { bg = "#2F4A4A" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { bg = "#2F4A2F" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { bg = "#4A3A2F" })
			vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { bg = "#4A4A2F" })
		end,
	},

	-- Rendered markdown in TUI
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		ft = { "markdown", "codecompanion" },
		opts = {
			heading = {
				sign = false,
				border = true,
				border_virtual = true,
			},
			code = {
				sign = false,
			},
			pipe_table = {
				cell = "trimmed",
			},
			checkbox = {
				checked = {
					scope_highlight = "@markup.strikethrough",
				},
			},
			completions = {
				lsp = {
					enabled = true,
				},
			},
			html = {
				enabled = true,
				tag = {
					buf = { icon = " ", highlight = "CodeCompanionChatVariable" },
					file = { icon = " ", highlight = "CodeCompanionChatVariable" },
					help = { icon = "󰘥 ", highlight = "CodeCompanionChatVariable" },
					image = { icon = " ", highlight = "CodeCompanionChatVariable" },
					symbols = { icon = " ", highlight = "CodeCompanionChatVariable" },
					url = { icon = "󰖟 ", highlight = "CodeCompanionChatVariable" },
					var = { icon = " ", highlight = "CodeCompanionChatVariable" },
					tool = { icon = " ", highlight = "CodeCompanionChatTool" },
					user_prompt = { icon = " ", highlight = "CodeCompanionChatTool" },
					user = { icon = " ", highlight = "CodeCompanionChatTool" },
					group = { icon = " ", highlight = "CodeCompanionChatToolGroup" },
				},
			},
		},
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
		opts = {
			use_icons = vim.g.have_nerd_font,
		},
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
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "BufReadPre",
		opts = {
			signs = false,
		},
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
				{ "<leader>n", group = "[N]otifications" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>s", group = "[S]ession" },
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

	-- Hightlight whitespace in visual selections
	{
		"mcauley-penney/visual-whitespace.nvim",
		event = "ModeChanged *:[vV\22]",
		opts = {
			list_chars = {
				space = vim.opt.listchars:get().space,
				tab = vim.opt.listchars:get().tab,
				nbsp = vim.opt.listchars:get().nbsp,
			},
			ignore = {
				filetypes = {
					"minifiles",
					"neo-tree",
					"codecompanion",
				},
			},
		},
		config = function(ctx)
			require("visual-whitespace").setup(ctx.opts)
			vim.api.nvim_set_hl(0, "VisualNonText", { fg = "#6272a4", bg = "#44475a" })
		end,
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
			background_colour = "Normal",
		},
		config = function(ctx)
			require("notify").setup(ctx.opts)
			vim.notify = require("notify")
		end,
	},

	-- Display relative line numbers only in modes where it makes sense
	{
		"sitiom/nvim-numbertoggle",
		event = {
			"BufEnter",
			"FocusGained",
			"InsertLeave",
			"CmdlineLeave",
			"WinEnter",
			"BufLeave",
			"FocusLost",
			"InsertEnter",
			"CmdlineEnter",
			"WinLeave",
		},
	},

	-- Dim inactive windows
	{
		"tadaa/vimade",
		event = "VeryLazy",
		opts = {
			recipe = { "default", { animate = true } },
			ncmode = "windows",
			fadelevel = 0.5,
			enablefocusfading = true,
		},
	},
}
