return {
	-- Columnar File Explorer
	{
		"echasnovski/mini.files",
		version = false,
		event = function()
			-- Load when opening a directory
			if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
				return "VimEnter"
			end
			return false
		end,
		keys = {
			{
				"<leader>e",
				function()
					local MiniFiles = require("mini.files")
					if not MiniFiles.close() then
						MiniFiles.open(vim.uv.cwd(), true)
					end
				end,
				desc = "[E]xplorer Panes",
			},
		},
		opts = {
			options = {
				use_as_default_explorer = true,
			},
		},
		config = function(ctx)
			require("mini.files").setup(ctx.opts)
		end,
	},

	-- Session Management
	{
		"echasnovski/mini.sessions",
		version = false,
		event = "VeryLazy",
		opts = {
			file = "",
		},
		config = function(ctx)
			require("mini.sessions").setup(ctx.opts)
		end,
	},

	-- Dashboard
	{
		"echasnovski/mini.starter",
		dependencies = { "echasnovski/mini.sessions" },
		version = false,
		event = function()
			if vim.fn.argc() == 0 then
				return "VimEnter"
			end
		end,
		config = function(ctx)
			starter = require("mini.starter")
			starter.setup({
				evaluate_single = true,
				header = "",
				items = {
					starter.sections.sessions(),
					starter.sections.recent_files(nil, nil, false),
					{ name = "New Buffer", action = "enew", section = "Builtin actions" },
					{ name = "File Explorer", action = "Neotree", section = "Builtin actions" },
				},
				content_hooks = {
					starter.gen_hook.adding_bullet(),
					starter.gen_hook.aligning("center", "center"),
				},
				footer = "",
			})
			vim.cmd("highlight! link MiniStarterCurrent DraculaFgBold")
			vim.cmd("highlight! link MiniStarterFooter DraculaComment")
			vim.cmd("highlight! link MiniStarterHeader DraculaCyan")
			vim.cmd("highlight! link MiniStarterInactive DraculaSubtle")
			vim.cmd("highlight! link MiniStarterItem DraculaComment")
			vim.cmd("highlight! link MiniStarterItemBullet DraculaComment")
			vim.cmd("highlight! link MiniStarterItemPrefix DraculaPink")
			vim.cmd("highlight! link MiniStarterSection DraculaPurpleBold")
			vim.cmd("highlight DraculaPinkInverse guifg=#282A36 guibg=#FF79C6 ctermfg=236 ctermbg=212")
			vim.cmd("highlight! link MiniStarterQuery DraculaPinkInverse")
		end,
	},

	-- Tree File Explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		event = function()
			-- Load when opening a directory
			if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
				return "VimEnter"
			end
			return false
		end,
		cmd = { "Neotree" },
		keys = {
			{ "<leader>E", "<cmd>Neotree toggle<cr>", desc = "[E]xplorer Tree" },
		},
		opts = {
			close_if_last_window = true,
			enable_diagnostics = false,
			enable_cursor_hijack = true,
			popup_border_style = "",
			default_component_configs = {
				name = {
					trailing_slash = true,
					highlight_opened_files = false,
				},
				git_status = {
					symbols = {
						-- Change type
						added = "+",
						deleted = "-",
						modified = "~",
						renamed = "»",
						-- Status type
						untracked = "?",
						ignored = "x",
						unstaged = "",
						staged = "●",
						conflict = "!",
					},
				},
			},
			window = {
				position = "right",
			},
			filesystem = {
				hijack_netrw_behavior = "disabled",
				use_libuv_file_watcher = true,
			},
			-- TOOD key mappings in window, filesyste, buffers, git_status, document_symbols, example
		},
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons" },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					fzf = {},
					["ui-select"] = {},
				},
			})
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")
		end,
	},
}
