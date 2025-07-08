-- Clear search highlights
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostics
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, {
	desc = "Open diagnostic [Q]uickfix list",
})

-- Exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", {
	desc = "Exit terminal mode",
})

-- Keybinds to make split navigation easier
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- ... also split manipulation
vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })
-- Unmap arrow keys
vim.keymap.set("n", "<Up>", "<Nop>", { desc = "Disable Up Arrow" })
vim.keymap.set("n", "<Down>", "<Nop>", { desc = "Disable Down Arrow" })
vim.keymap.set("n", "<Left>", "<Nop>", { desc = "Disable Left Arrow" })
vim.keymap.set("n", "<Right>", "<Nop>", { desc = "Disable Right Arrow" })

-- Treesitter Keymaps
local function map_textobject(lhs, query, desc)
	vim.keymap.set({ "x", "o" }, lhs, function()
		require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
	end, { desc = desc })
end
map_textobject("af", "@function.outer", "function")
map_textobject("if", "@function.inner", "inner function")
map_textobject("ac", "@comment.outer", "comment")
map_textobject("ic", "@comment.inner", "inner comment")

-- Telescope Keymaps
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
