-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", {
		clear = true,
	}),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Treesitter highlighting and indenting
vim.api.nvim_create_autocmd("FileType", {
	desc = "User: enable treesitter highlighting",
	callback = function(ctx)
		local hasStarted = pcall(vim.treesitter.start) -- errors for filetypes with no parser

		local noIndent = {}
		if hasStarted and not vim.list_contains(noIndent, ctx.match) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end
	end,
})

-- Auto-Linting
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		if vim.bo.modifiable then
			require("lint").try_lint()
		end
	end,
})
