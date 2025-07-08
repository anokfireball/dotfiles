return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "mason-org/mason.nvim", opts = {} },
		{ "mason-org/mason-lspconfig.nvim", opts = {} },
		"nvimtools/none-ls.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	opts = {
		ensure_installed = {
			-- bash
			"bashls",
			"shellcheck",
			"shfmt",
			-- GitHub Actions
			"gh-actions-language-server",
			"actionlint",
			-- lua
			"lua_ls",
			"luacheck",
			"stylua",
			--python
			"basedpyright",
			"ruff",
			--yaml
			"yamlls",
			"yamllint",
			"yamlfmt",
		},
	},
	config = function(ctx)
		require("mason-tool-installer").setup(ctx.opts)
		-- https://docs.basedpyright.com/dev/configuration/language-server-settings/
		-- turn off some things that should be delegated to ruff
		vim.lsp.config("basedpyright", {
			settings = {
				basedpyright = {
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						ignore = { "*" },
					},
				},
			},
		})
		-- https://docs.astral.sh/ruff/editors/settings/#configuration
		vim.lsp.config("ruff", {})
	end,
}
