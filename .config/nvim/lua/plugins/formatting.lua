return {
	-- Auto-detect indentation
	{
		"NMAC427/guess-indent.nvim",
		event = "BufReadPre",
	},

	-- Code formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			formatters = {
				xmlfmt = {
					command = "xmlformatter",
					args = { "--indent", "4" },
				},
				golinesfmt = {
					command = "golines",
					args = { "--base-formatter", "gofumpt" },
				},
				goimportsfmt = {
					command = "goimports-reviser",
					args = { "-rm-unused", "-set-alias", "$FILENAME" },
					stdin = false,
				},
			},
			formatters_by_ft = {
				bash = { "shfmt" },
				ghaction = { "yamlfmt" },
				go = {
					"golinesfmt",
					"goimportsfmt",
				},
				json = { "prettier" },
				lua = { "stylua" },
				python = {
					"ruff_fix",
					"ruff_format",
					"ruff_organize_imports",
				},
				sh = { "shfmt" },
				xml = { "xmlfmt" },
				yaml = { "yamlfmt" },
				zsh = { "shfmt" },
			},
			format_on_save = function(bufnr)
				local filetype = vim.bo[bufnr].filetype
				local format_on_save_filetypes = {
					"go",
					"lua",
				}

				for _, ft in ipairs(format_on_save_filetypes) do
					if filetype == ft then
						return { lsp_format = "fallback" }
					end
				end
				return nil
			end,
		},
	},
}
