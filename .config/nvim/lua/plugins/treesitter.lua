return {
	-- Parser + query manager (replaces archived nvim-treesitter)
	{
		"arborist-ts/arborist.nvim",
		lazy = false,
		config = function()
			require("arborist").setup({
				update_cadence = "weekly",
				install_popular = true,
				ensure_installed = {
					-- Languages beyond arborist's "popular" set that you use:
					"comment",
					"csv",
					"embedded_template",
					"git_config",
					"git_rebase",
					"gitattributes",
					-- "gitcommit",  -- arborist hangs silently (needs tree-sitter generate)
					"gitignore",
					"gomod",
					"gosum",
					"gotmpl",
					"gowork",
					"helm",
					"jinja",
					"jinja_inline",
					"luadoc",
					"mermaid",
					"query",
					"requirements",
					"ssh_config",
					-- "terraform",  -- arborist hangs silently (mono-repo dialect build)
					-- "tmux",       -- arborist hangs silently
				},
				disable = {
					highlight = {
						-- Plain text
						"txt",
						"text",
						"plaintex",
						-- Documentation
						"help",
						"man",
						"info",
						-- Git interfaces
						"git",
						"fugitive",
						"gitcommit",
						"gitrebase",
						"gitconfig",
						-- Simple configs
						"dosini",
						"properties",
						"conf",
					},
				},
			})

			vim.treesitter.language.register("yaml", "ghaction")
		end,
	},

	-- Treesitter text objects (select, move, swap)
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"arborist-ts/arborist.nvim",
			-- Sticky context (function headers at top of screen)
			{
				"nvim-treesitter/nvim-treesitter-context",
				event = "BufReadPre",
				opts = {},
			},
		},
		event = "BufReadPre",
		branch = "main",
		opts = {
			select = {
				lookahead = true,
			},
		},
	},
}
