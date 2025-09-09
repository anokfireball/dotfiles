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

	-- LSP configuration for auto-starting servers
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.lsp.config("gh_actions_ls", {
				filetypes = { "ghaction" },
			})

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

			require("mason-lspconfig").setup({
				automatic_enable = true,
			})
		end,
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
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
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
			auto_update = true,
		},
	},
}
