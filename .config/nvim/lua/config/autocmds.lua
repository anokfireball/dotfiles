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
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	callback = function()
		if vim.bo.modifiable then
			require("lint").try_lint()
		end
	end,
})

-- Proper interactiion between Copilot and Blink
vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuOpen",
	callback = function()
		vim.b.copilot_suggestion_hidden = true
		require("copilot.suggestion").dismiss()
	end,
})
vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpMenuClose",
	callback = function()
		vim.b.copilot_suggestion_hidden = false
	end,
})

-- Remove trailing whitespace and multiple empty lines at EOF on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function()
		local exclude_ft = {
			-- Documentation formats where whitespace is meaningful
			"markdown",
			"md",
			"rst",
			"asciidoc",
			"adoc",
			"tex",
			"latex",

			-- Version control and diffs
			"diff",
			"patch",
			"gitcommit",
			"gitrebase",
			"gitconfig",
			"fugitive",
			"fugitiveblame",

			-- Special text formats
			"mail",
			"eml",
			"csv",
			"tsv",
			"log",
			"text",
			"txt",

			-- Binary-ish or special formats
			"binary",
			"xxd",
			"terminal",
			"toggleterm",

			-- Plugin-specific buffers
			"TelescopePrompt",
			"TelescopeResults",
			"NvimTree",
			"neo-tree",
			"help",
			"man",
			"qf",
			"quickfix",
			"oil",

			-- Language-specific cases
			"make",
			"makefile",
		}

		if vim.tbl_contains(exclude_ft, vim.bo.filetype) then
			return
		end

		local save_cursor = vim.fn.getpos(".")

		-- Remove trailing whitespace
		vim.cmd([[%s/\s\+$//e]])

		-- Reduce multiple empty lines at EOF to at most one
		vim.cmd([[%s/\n\n\+\%$/\r/e]])

		vim.fn.setpos(".", save_cursor)
	end,
	desc = "Remove trailing whitespace and multiple empty lines at EOF",
})
