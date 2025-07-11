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

				vim.treesitter.language.register("yaml", "ghaction")
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
			opts = {},
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
