return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "mason-org/mason.nvim", opts = {} },
		{ "mason-org/mason-lspconfig.nvim", opts = {} },
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
			-- Go
			"gopls",
			"golangci-lint",
			"goimports",
			-- JSON
			"jsonls",
			"jsonlint",
			"prettier",
			-- lua
			"lua_ls",
			"luacheck",
			"stylua",
			--python
			"basedpyright",
			"ruff",
			-- xml
			"lemminx",
			"xmlformatter",
			--yaml
			"yamlls",
			"yamllint",
			"yamlfmt",
		},
	},
	config = function(ctx)
		require("mason-tool-installer").setup(ctx.opts)

		-- Associate with custom filetype
		require("lspconfig").gh_actions_ls.setup({
			filetypes = { "ghaction" },
		})
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
