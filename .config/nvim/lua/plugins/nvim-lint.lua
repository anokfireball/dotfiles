return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("lint").linters_by_ft = {
			ghaction = { 'actionlint' },
			yaml = { "yamllint" },
		}
	end,
}
