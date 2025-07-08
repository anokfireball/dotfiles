return {
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

				local filetypes = vim.fn.getcompletion("", "filetype")
				local blacklist = {
					"mason",
					"qf",
				}
				local supported_filetypes = {}
				for _, ft in ipairs(filetypes) do
					if not vim.tbl_contains(blacklist, ft) then
						table.insert(supported_filetypes, ft)
					end
				end
				vim.api.nvim_create_autocmd("FileType", {
					pattern = supported_filetypes,
					callback = function()
						vim.treesitter.start()
					end,
				})

				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		},
	},
	lazy = false,
	branch = "main",
	opts = {
		select = {
			lookahead = true,
		},
	},
}
