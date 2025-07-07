return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	opts = {
		ensure_installed = {
			-- bash
			"bashls",
			"shellcheck",
			"shfmt",
			-- lua
			"lua_ls",
			"luacheck",
			"stylua",
		},
	},
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "mason-org/mason.nvim", opts = {} },
		{ "mason-org/mason-lspconfig.nvim", opts = {} },
		"nvimtools/none-ls.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
}
