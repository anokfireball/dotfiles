return {
	-- Enhanced Lua development
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	-- Linting
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("lint").linters_by_ft = {
				ghaction = { "actionlint" },
				yaml = { "yamllint" },
			}
		end,
	},

	-- LSP servers installation and configuration
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		dependencies = {
			{ "mason-org/mason-lspconfig.nvim", opts = {} },
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
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
	},
}

