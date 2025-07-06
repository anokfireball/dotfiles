return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-tree/nvim-web-devicons" },
		-- extensions
		{ "nvim-telescope/telescope-fzf-native.nvim" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
	},
	config = function()
		require("telescope").setup({
			extensions = {
				fzf = {},
				["ui-select"] = {},
			},
		})
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("ui-select")

		local ts = require("telescope.builtin")
		vim.keymap.set("n", "<leader>f.", ts.current_buffer_fuzzy_find, { desc = "[F]ind in Current Buffer" })
		vim.keymap.set("n", "<leader>fb", ts.buffers, { desc = "[F]ind [B]uffers" })
		vim.keymap.set("n", "<leader>fd", ts.diagnostics, { desc = "[F]ind [D]iagnostics" })
		vim.keymap.set("n", "<leader>ff", ts.find_files, { desc = "[F]ind [F]iles" })
		vim.keymap.set("n", "<leader>fg", ts.live_grep, { desc = "[F]ind by [G]rep" })
		vim.keymap.set("n", "<leader>fh", ts.help_tags, { desc = "[F]ind [H]elp" })
		vim.keymap.set("n", "<leader>fk", ts.keymaps, { desc = "[F]ind [K]eymaps" })
		vim.keymap.set("n", "<leader>fn", function()
			ts.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[F]ind [N]eovim files" })
		vim.keymap.set("n", "<leader>fo", ts.live_grep, { desc = "[F]ind [O]pen Files" })
		vim.keymap.set("n", "<leader>fr", ts.oldfiles, { desc = "[F]ind [R]ecent Files" })
		vim.keymap.set("n", "<leader>ft", ts.builtin, { desc = "[F]ind [T]elescope Builtins" })
		vim.keymap.set("n", "<leader>fw", ts.grep_string, { desc = "[F]ind current [W]ord" })
	end,
}
