return {
	-- Enhanced Lua development
	{
		"folke/lazydev.nvim",
		dependencies = {
			{ "DrKJeff16/wezterm-types", lazy = true },
		},
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "wezterm-types", mods = { "wezterm" } },
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

			vim.lsp.config("gh_actions_ls", {
				filetypes = { "ghaction" },
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
				bash = { "shellcheck" },
				dockerfile = { "hadolint" },
				ghaction = { "actionlint" },
				go = { "golangcilint" },
				json = { "jsonlint" },
				lua = { "luacheck" },
				python = {
					"mypy",
					"ruff",
				},
				sh = { "shellcheck" },
				yaml = { "yamllint" },
				zsh = { "shellcheck" },
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
			"jay-babu/mason-nvim-dap.nvim",
		},
		opts = {
			ensure_installed = {
				-- bash
				"bashls",
				"shellcheck",
				"shfmt",
				-- Docker
				"docker-language-server",
				"hadolint",
				-- GitHub Actions
				"gh-actions-language-server",
				"actionlint",
				-- Go
				"gopls",
				"delve",
				"golangci-lint",
				"gofumpt",
				"goimports-reviser",
				"golines",
				-- Helm
				"helm-ls",
				"kube-linter",
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
				"debugpy",
				"mypy",
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
