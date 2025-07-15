return {
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
		formatters_by_ft = {
			bash = { "shfmt" },
			ghaction = { "yamlfmt" },
			json = { "prettier" },
			lua = { "stylua" },
			python = {
				"ruff_fix",
				"ruff_format",
				"ruff_organize_imports",
			},
			yaml = { "yamlfmt" },
		},
	},
}
