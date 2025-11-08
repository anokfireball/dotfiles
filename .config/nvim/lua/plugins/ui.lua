return {
	-- Buffer line (with tabpage integration)
	{
		"akinsho/bufferline.nvim",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "BufReadPre",
		opts = {
			options = {
				numbers = function(opts)
					return string.format(" %s", opts.ordinal)
				end,
				indicator = {
					icon = "",
					style = "none",
				},
				show_buffer_icons = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				persist_buffer_sort = true,
				enforce_regular_tabs = false,
				separator_style = { "", "" },
				tab_size = 1,
				show_duplicate_prefix = true,
				custom_areas = {
					left = function()
						local buf_count = 0

						local ok, buffers = pcall(function()
							return vim.tbl_filter(function(buf)
								return vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted
							end, vim.api.nvim_list_bufs())
						end)

						if ok then
							buf_count = #buffers
						else
							buf_count = math.max(1, #vim.fn.getbufinfo({ buflisted = 1 }))
						end

						local screen_width = vim.o.columns
						-- TODO should get actual content width instead of guesstimating
						local avg_tab_width = 20
						local total_content_width = math.min(buf_count * avg_tab_width, screen_width * 0.7)

						local padding_size = math.max(0, math.floor((screen_width - total_content_width) / 2))

						return {
							{ text = string.rep(" ", padding_size), link = "BufferLineFill" },
						}
					end,
				},
			},
			highlights = {
				fill = {
					bg = "#343746",
				},
				background = {
					fg = "#6272a4",
					bg = "#343746",
				},
				tab = {
					fg = "#6272a4",
					bg = "#343746",
				},
				tab_selected = {
					fg = "#f8f8f2",
					bg = "#6272a4",
					bold = true,
				},
				tab_close = {
					fg = "#6272a4",
					bg = "#343746",
				},
				close_button = {
					fg = "#6272a4",
					bg = "#343746",
				},
				close_button_visible = {
					fg = "#6272a4",
					bg = "#343746",
				},
				close_button_selected = {
					fg = "#f8f8f2",
					bg = "#6272a4",
				},
				buffer_visible = {
					fg = "#6272a4",
					bg = "#343746",
				},
				buffer_selected = {
					fg = "#f8f8f2",
					bg = "#6272a4",
					bold = true,
					italic = false,
				},
				numbers = {
					fg = "#6272a4",
					bg = "#343746",
					bold = true,
					italic = false,
				},
				numbers_visible = {
					fg = "#6272a4",
					bg = "#343746",
					bold = true,
					italic = false,
				},
				numbers_selected = {
					fg = "#f8f8f2",
					bg = "#6272a4",
					bold = true,
					italic = false,
				},
				diagnostic = {
					fg = "#6272a4",
					bg = "#343746",
				},
				diagnostic_visible = {
					fg = "#6272a4",
					bg = "#343746",
				},
				diagnostic_selected = {
					fg = "#f8f8f2",
					bg = "#6272a4",
					bold = true,
				},
				hint = {
					fg = "#50fa7b",
					bg = "#343746",
				},
				hint_visible = {
					fg = "#50fa7b",
					bg = "#343746",
				},
				hint_selected = {
					fg = "#50fa7b",
					bg = "#6272a4",
					bold = true,
				},
				hint_diagnostic = {
					fg = "#50fa7b",
					bg = "#343746",
				},
				hint_diagnostic_visible = {
					fg = "#50fa7b",
					bg = "#343746",
				},
				hint_diagnostic_selected = {
					fg = "#50fa7b",
					bg = "#6272a4",
					bold = true,
				},
				info = {
					fg = "#8be9fd",
					bg = "#343746",
				},
				info_visible = {
					fg = "#8be9fd",
					bg = "#343746",
				},
				info_selected = {
					fg = "#8be9fd",
					bg = "#6272a4",
					bold = true,
				},
				info_diagnostic = {
					fg = "#8be9fd",
					bg = "#343746",
				},
				info_diagnostic_visible = {
					fg = "#8be9fd",
					bg = "#343746",
				},
				info_diagnostic_selected = {
					fg = "#8be9fd",
					bg = "#6272a4",
					bold = true,
				},
				warning = {
					fg = "#ffb86c",
					bg = "#343746",
				},
				warning_visible = {
					fg = "#ffb86c",
					bg = "#343746",
				},
				warning_selected = {
					fg = "#ffb86c",
					bg = "#6272a4",
					bold = true,
				},
				warning_diagnostic = {
					fg = "#ffb86c",
					bg = "#343746",
				},
				warning_diagnostic_visible = {
					fg = "#ffb86c",
					bg = "#343746",
				},
				warning_diagnostic_selected = {
					fg = "#ffb86c",
					bg = "#6272a4",
					bold = true,
				},
				error = {
					fg = "#ff5555",
					bg = "#343746",
				},
				error_visible = {
					fg = "#ff5555",
					bg = "#343746",
				},
				error_selected = {
					fg = "#ff5555",
					bg = "#6272a4",
					bold = true,
				},
				error_diagnostic = {
					fg = "#ff5555",
					bg = "#343746",
				},
				error_diagnostic_visible = {
					fg = "#ff5555",
					bg = "#343746",
				},
				error_diagnostic_selected = {
					fg = "#ff5555",
					bg = "#6272a4",
					bold = true,
				},
				modified = {
					fg = "#bd93f9",
					bg = "#343746",
				},
				modified_visible = {
					fg = "#bd93f9",
					bg = "#343746",
				},
				modified_selected = {
					fg = "#bd93f9",
					bg = "#6272a4",
				},
				duplicate_selected = {
					fg = "#f8f8f2",
					bg = "#6272a4",
				},
				duplicate_visible = {
					fg = "#6272a4",
					bg = "#343746",
				},
				duplicate = {
					fg = "#6272a4",
					bg = "#343746",
				},
				separator_selected = {
					fg = "#343746",
					bg = "#343746",
				},
				separator_visible = {
					fg = "#343746",
					bg = "#343746",
				},
				separator = {
					fg = "#343746",
					bg = "#343746",
				},
				indicator_selected = {
					fg = "#bd93f9",
					bg = "#6272a4",
				},
				indicator_visible = {
					fg = "#343746",
					bg = "#343746",
				},
				pick_selected = {
					fg = "#ff79c6",
					bg = "#6272a4",
					bold = true,
				},
				pick_visible = {
					fg = "#ff79c6",
					bg = "#343746",
					bold = true,
				},
				pick = {
					fg = "#ff79c6",
					bg = "#343746",
					bold = true,
				},
				offset_separator = {
					fg = "#343746",
					bg = "#282a36",
				},
				trunc_marker = {
					fg = "#6272a4",
					bg = "#343746",
				},
			},
		},
		config = function(ctx)
			require("bufferline").setup(ctx.opts)
			for i = 1, 9 do
				vim.keymap.set("n", "<leader>" .. i, "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", { silent = true })
			end
		end,
	},

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

	-- Contextual QoL improvement to search highlighting
	{
		"kevinhwang91/nvim-hlslens",
		version = "*",
		event = "BufReadPre",
		config = function(ctx)
			require("hlslens").setup(ctx.opts)

			vim.api.nvim_set_hl(0, "HlSearchLens", { link = "Search" })
			vim.api.nvim_set_hl(0, "HlSearchLensNear", { link = "CurSearch" })
			vim.api.nvim_set_hl(0, "HlSearchNear", { link = "CurSearch" })

			local opts = { noremap = true, silent = true }
			local map = function(lhs, rhs)
				vim.keymap.set("n", lhs, rhs, opts)
			end

			map("n", function()
				local ok = pcall(vim.cmd, "normal! " .. tostring(vim.v.count1) .. "n")
				if ok then
					require("hlslens").start()
				end
			end)
			map("N", function()
				local ok = pcall(vim.cmd, "normal! " .. tostring(vim.v.count1) .. "N")
				if ok then
					require("hlslens").start()
				end
			end)

			for _, k in ipairs({ "*", "#", "g*", "g#" }) do
				map(k, function()
					local ok = pcall(vim.cmd, "normal! " .. k)
					if ok then
						require("hlslens").start()
					end
				end)
			end
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

			-- Function to get copilot status for statusline
			local function copilot_status()
				local robot = "󰚩"

				local buffer_auto_trigger = vim.b.copilot_suggestion_auto_trigger
				local global_auto_trigger = vim.g.copilot_auto_trigger_global

				local effective_state
				if buffer_auto_trigger ~= nil then
					effective_state = buffer_auto_trigger
				elseif global_auto_trigger ~= nil then
					effective_state = global_auto_trigger
				else
					effective_state = false -- Default disabled
				end

				if not effective_state then
					return robot .. " -"
				end

				return robot .. " +"
			end

			-- Function to get diagnostic level status for statusline
			local function diagnostic_level_status()
				local bulb = "󰛩"

				local severity = vim.g.min_diagnostic_severity

				if not vim.diagnostic.is_enabled() or severity == nil then
					return bulb .. " -"
				end

				if severity == vim.diagnostic.severity.ERROR then
					return bulb .. " W"
				elseif severity == vim.diagnostic.severity.HINT then
					return bulb .. " A"
				end

				return bulb .. " ?"
			end

			statusline.setup(ctx.opts)

			-- Custom location section
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- Custom content with copilot status
			statusline.config.content = {
				active = function()
					local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
					local git = statusline.section_git({ trunc_width = 40 })
					local diff = statusline.section_diff({ trunc_width = 75 })
					local diagnostics = statusline.section_diagnostics({ trunc_width = 75 })
					local lsp = statusline.section_lsp({ trunc_width = 75 })
					local filename = statusline.section_filename({ trunc_width = 140 })
					local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
					local location = statusline.section_location({ trunc_width = 75 })
					local search = statusline.section_searchcount({ trunc_width = 75 })
					local copilot = copilot_status()
					local diag_level = diagnostic_level_status()

					-- Format git branch and filename with file icon (no explicit delimiter)
					local git_branch = ""
					if git ~= "" then
						git_branch = git:gsub("^%s+", ""):gsub("%s+$", "")
					end

					local file_icon = ""
					local filename_with_icon = ""
					if filename ~= "" then
						filename_with_icon = file_icon .. " " .. filename
					end

					return statusline.combine_groups({
						{ hl = mode_hl, strings = { mode } },
						{ hl = "MiniStatuslineDevinfo", strings = { diff, diagnostics, lsp, copilot, diag_level } },
						"%<", -- Mark general truncate point
						{ hl = "MiniStatuslineFilename", strings = { filename_with_icon } },
						"%=", -- End left alignment
						{ hl = "MiniStatuslineFilename", strings = { git_branch } },
						{ hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
						{ hl = mode_hl, strings = { search, location } },
					})
				end,
			}
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
		event = "VimEnter",
		opts = {
			recipe = { "default", { animate = true } },
			ncmode = "windows",
			fadelevel = 0.5,
			enablefocusfading = true,
		},
	},

	-- Smarter folding
	{
		"chrisgrieser/nvim-origami",
		event = "BufReadPre",
		opts = {
			foldtext = {
				diagnosticsCount = false,
				gitsignsCount = false,
			},
			autoFold = {
				kinds = { "imports" },
			},
		},
		init = function()
			vim.o.foldcolumn = "0"
			vim.o.foldlevel = 99
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true
		end,
	},
}
