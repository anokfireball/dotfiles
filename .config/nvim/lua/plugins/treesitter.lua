return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter",
				branch = "main",
				build = ":TSUpdate",
				config = function(ctx)
					local ts = require("nvim-treesitter")
					ts.setup(ctx.opts)

					local languages = {
						"bash",
						"c",
						"comment",
						"cpp",
						"csv",
						"diff",
						"dockerfile",
						"embedded_template",
						"git_config",
						"git_rebase",
						"gitattributes",
						"gitcommit",
						"gitignore",
						"go",
						"gomod",
						"gosum",
						"gotmpl",
						"gowork",
						"helm",
						"html",
						"ini",
						"jinja",
						"jinja_inline",
						"json",
						"lua",
						"luadoc",
						"markdown",
						"markdown_inline",
						"mermaid",
						"python",
						"query",
						"regex",
						"requirements",
						"ssh_config",
						"terraform",
						"tmux",
						"toml",
						"vimdoc",
						"xml",
						"yaml",
					}
					ts.install(languages)

					vim.treesitter.language.register("yaml", "ghaction")
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			},
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {},
			},
		},
		event = "BufReadPre",
		init = function()
			-- Define filetypes to exclude from treesitter
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ft = vim.bo[args.buf].filetype
					local buftype = vim.bo[args.buf].buftype

					-- Skip special buffer types
					if buftype ~= "" then
						return
					end

					local blacklist = {
						-- Plain text
						"txt",
						"text",
						"plaintex",

						-- Special UI buffers from plugins
						"neo-tree",
						"minifiles",
						"starter",
						"WhichKey",
						"notify",
						"TelescopePrompt",
						"TelescopeResults",
						"TelescopePreview",

						-- Documentation (unless editing)
						"help",
						"man",
						"info",

						-- Git interfaces
						"git",
						"fugitive",
						"gitcommit",
						"gitrebase",
						"gitconfig",

						-- Simple configs
						"dosini",
						"properties",
						"conf",
					}

					if vim.tbl_contains(blacklist, ft) then
						-- Disable treesitter for this buffer
						-- Only try to disable if treesitter module is available
						pcall(function()
							require("nvim-treesitter.configs").setup({
								highlight = {
									enable = false,
								},
							})
						end)
					end
				end,
			})
		end,
		branch = "main",
		opts = {
			select = {
				lookahead = true,
			},
			move = {
				enable = false,
			},
		},
	},
}
