return {
	-- Premade Go config for nvim-dap
	{
		"leoluz/nvim-dap-go",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "go",
		opts = {
			delve = {
				path = vim.fn.stdpath("data") .. "/mason/packages/delve/dlv",
			},
		},
	},

	-- Debug Adapter Protocol
	{
		"mfussenegger/nvim-dap",
	},

	-- Premade Python config for nvim-dap
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python",
		config = function()
			local path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)
		end,
	},
}
