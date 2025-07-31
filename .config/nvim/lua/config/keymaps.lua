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

-- split creation consistent with tmux
vim.keymap.set("n", "<C-w>-", "<cmd>split<CR>", { desc = "Horizontal Split" })
vim.keymap.set("n", "<C-w>|", "<cmd>vsplit<CR>", { desc = "Vertical Split" })
-- make split navigation easier
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

vim.keymap.set("n", "<leader>E", function()
	vim.cmd("Neotree toggle")
end, { desc = "[E]xplorer Tree" })

vim.keymap.set("n", "<leader>e", function()
	local MiniFiles = require("mini.files")
	if MiniFiles.get_explorer_state() ~= nil then
		MiniFiles.close()
	else
		MiniFiles.open(vim.uv.cwd(), true)
	end
end, { desc = "[E]xplorer Panes" })

-- Treesitter Keymaps
local function map_textobject(lhs, textobject, desc)
	vim.keymap.set({ "x", "o" }, lhs, function()
		require("nvim-treesitter-textobjects.select").select_textobject(textobject, "textobjects")
	end, { desc = desc })
end
map_textobject("af", "@function.outer", "function")
map_textobject("if", "@function.inner", "inner function")
map_textobject("ac", "@comment.outer", "comment")
map_textobject("ic", "@comment.inner", "inner comment")

-- Telescope Keymaps
local function map_telescope(lhs, func, desc)
	vim.keymap.set("n", lhs, function()
		require("telescope.builtin")[func]()
	end, { desc = desc })
end
map_telescope("<leader>f.", "current_buffer_fuzzy_find", "[F]ind in Current Buffer")
map_telescope("<leader>fb", "buffers", "[F]ind [B]uffers")
map_telescope("<leader>fd", "diagnostics", "[F]ind [D]iagnostics")
map_telescope("<leader>ff", "find_files", "[F]ind [F]iles")
-- vim.keymap.set("n", "<leader>ff", function()
-- 	require("telescope").extensions.frecency.frecency({})
-- end, { desc = "[F]ind [F]iles" })
map_telescope("<leader>fg", "live_grep", "[F]ind by [G]rep")
-- vim.keymap.set("n", "<leader>fg", function()
-- 	local frecency = require("telescope").extensions.frecency
-- 	require("telescope.builtin").live_grep({
-- 		search_dirs = frecency.query({}),
-- 	})
-- end, { desc = "[F]ind by [G]rep" })
map_telescope("<leader>fh", "help_tags", "[F]ind [H]elp")
map_telescope("<leader>fk", "keymaps", "[F]ind [K]eymaps")
vim.keymap.set("n", "<leader>fc", function()
	require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
	-- require("telescope").extensions.frecency.frecency({
	-- 	workspace = "NVIM",
	-- })
end, { desc = "[F]ind Neovim [C]onfigs" })
map_telescope("<leader>fo", "live_grep", "[F]ind [O]pen Files")
map_telescope("<leader>fr", "oldfiles", "[F]ind [R]ecent Files")
map_telescope("<leader>ft", "builtin", "[F]ind [T]elescope Builtins")
map_telescope("<leader>fw", "grep_string", "[F]ind current [W]ord")
vim.keymap.set("n", "<leader>fn", function()
	vim.cmd("Telescope notify")
end, { desc = "[F]ind [N]otifications" })

-- Toggles
vim.keymap.set("n", "<leader>td", function()
	if vim.g.min_diagnostic_severity == vim.diagnostic.severity.ERROR then
		vim.g.min_diagnostic_severity = vim.diagnostic.severity.HINT
	elseif vim.g.min_diagnostic_severity == vim.diagnostic.severity.HINT then
		vim.g.min_diagnostic_severity = nil
		vim.diagnostic.enable(false)
	else
		vim.g.min_diagnostic_severity = vim.diagnostic.severity.ERROR
		vim.diagnostic.enable(true)
	end
	Set_diagnostic_severity(vim.g.min_diagnostic_severity)
end, { desc = "[T]oggle [D]iagnostic Severity" })
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		vim.keymap.set("n", "<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
		end, { buffer = event.buf, desc = "[T]oggle Inlay [H]ints" })
	end,
})
vim.keymap.set("n", "<leader>tc", function()
	require("treesitter-context").toggle()
end, { desc = "[T]oggle [C]ontext" })
vim.keymap.set("n", "<leader>ta", function()
	local output = vim.api.nvim_exec("Copilot status", { output = true })
	if output:match("Ready") then
		vim.cmd("Copilot disable")
	else
		vim.cmd("Copilot enable")
	end
end, { desc = "[T]oggle Copilot [A]utocomplete" })
vim.keymap.set("n", "<leader>tf", function()
	vim.cmd("VimadeFocus")
end, { desc = "[T]oggle [F]ocus" })

-- GitSigns
GitSignsOnAttach = function(bufnr)
	local gitsigns = require("gitsigns")
	-- https://github.com/lewis6991/gitsigns.nvim/issues/255#issuecomment-2099420323
	local hl = vim.api.nvim_get_hl_by_name("Comment", true)
	vim.api.nvim_set_hl(0, "Blame", {
		fg = hl.foreground,
		bg = hl.background,
		italic = true,
	})
	vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Blame" })

	local function map_gitsigns(mode, lhs, func, desc)
		vim.keymap.set(mode, lhs, func, { desc = desc, buffer = bufnr })
	end

	-- Navigation
	map_gitsigns("n", "]c", function()
		if vim.wo.diff then
			vim.cmd.normal({ "]c", bang = true })
		else
			gitsigns.nav_hunk("next")
		end
	end, "hunk")
	map_gitsigns("n", "[c", function()
		if vim.wo.diff then
			vim.cmd.normal({ "[c", bang = true })
		else
			gitsigns.nav_hunk("prev")
		end
	end, "hunk")

	-- Actions
	map_gitsigns("n", "<leader>vs", gitsigns.stage_hunk, "[V]CS [S]tage Hunk")
	map_gitsigns("n", "<leader>vr", gitsigns.reset_hunk, "[V]CS [R]eset Hunk")

	map_gitsigns("v", "<leader>vs", function()
		gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, "[V]CS [S]tage Hunk")
	map_gitsigns("v", "<leader>vr", function()
		gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
	end, "[V]CS [R]eset Hunk")

	map_gitsigns("n", "<leader>vS", gitsigns.stage_buffer, "[V]CS [S]tage Buffer")
	map_gitsigns("n", "<leader>vR", gitsigns.reset_buffer, "[V]CS [R]eset Buffer")
	map_gitsigns("n", "<leader>vp", gitsigns.preview_hunk, "[V]CS [P]review Hunk")
	map_gitsigns("n", "<leader>vi", gitsigns.preview_hunk_inline, "[V]CS [I]nline Hunk")

	map_gitsigns("n", "<leader>vb", function()
		gitsigns.blame_line({ full = true })
	end, "[V]CS [B]lame Line")

	map_gitsigns("n", "<leader>vQ", function()
		gitsigns.setqflist("all")
	end, "[V]CS [Q]uickfix List All")
	map_gitsigns("n", "<leader>vq", gitsigns.setqflist, "[V]CS [Q]uickfix List")

	-- Toggles
	map_gitsigns("n", "<leader>tb", gitsigns.toggle_current_line_blame, "[T]oggle Current Line [B]lame")
	map_gitsigns("n", "<leader>tw", gitsigns.toggle_word_diff, "[T]oggle [W]ord Diff")

	-- Text object
	map_gitsigns({ "o", "x" }, "ih", gitsigns.select_hunk, "[V]CS [I]nner Hunk")
end
vim.keymap.set("n", "<leader>vd", function()
	vim.cmd("DiffviewOpen")
end, { desc = "[V]CS [D]iffview" })

local function open_diffview(selection)
	if selection then
		vim.cmd("DiffviewOpen " .. (selection.value or selection[1]))
	end
end

local function telescope_git_tags(opts)
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	opts = opts or {}

	local tags = {}
	for tag in io.popen("git tag --sort=-creatordate"):lines() do
		table.insert(tags, tag)
	end

	pickers
		.new(opts, {
			prompt_title = "Git Tags",
			finder = finders.new_table({ results = tags }),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(_, map)
				local function on_select(prompt_bufnr)
					local selection = action_state.get_selected_entry(prompt_bufnr)
					actions.close(prompt_bufnr)
					open_diffview(selection)
				end
				map({ "i", "n" }, "<CR>", on_select)
				return true
			end,
		})
		:find()
end

vim.keymap.set("n", "<leader>vD", function()
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local builtin = require("telescope.builtin")
	local notify = vim.notify or print

	local function open_picker(picker_func, picker_name)
		if type(picker_func) ~= "function" then
			notify("Telescope picker '" .. (picker_name or "unknown") .. "' is not available.", vim.log.levels.ERROR)
			return
		end
		picker_func({
			attach_mappings = function(_, map)
				local function switch_picker(target_func, name)
					return function(prompt_bufnr)
						actions.close(prompt_bufnr)
						open_picker(target_func, name)
					end
				end
				local function on_select(prompt_bufnr)
					local selection = action_state.get_selected_entry(prompt_bufnr)
					actions.close(prompt_bufnr)
					open_diffview(selection)
				end
				map({ "i", "n" }, "<C-b>", switch_picker(builtin.git_branches, "git_branches"))
				map({ "i", "n" }, "<C-c>", switch_picker(builtin.git_commits, "git_commits"))
				map({ "i", "n" }, "<C-t>", switch_picker(telescope_git_tags, "git_tags"))
				map({ "i", "n" }, "<CR>", on_select)
				return true
			end,
		})
	end
	open_picker(builtin.git_branches, "git_branches")
end, { desc = "[V]CS [D]iffview Interactive (Switchable)" })

-- CodeCompanion
vim.keymap.set(
	{ "n", "v" },
	"<leader>ca",
	"<cmd>CodeCompanionActions<cr>",
	{ desc = "[C]odeCompanion [A]ctions", noremap = true, silent = true }
)
vim.keymap.set(
	{ "n", "v" },
	"<leader>cc",
	"<cmd>CodeCompanionChat Toggle<cr>",
	{ desc = "[C]odeCompanion [C]hat", noremap = true, silent = true }
)
vim.keymap.set(
	{ "n", "v" },
	"<leader>ce",
	"<cmd>CodeCompanion /explain<cr>",
	{ desc = "[C]odeCompanion [E]xplain", noremap = true, silent = true }
)
vim.keymap.set(
	{ "n", "v" },
	"<leader>cf",
	"<cmd>CodeCompanion /fix<cr>",
	{ desc = "[C]odeCompanion [F]ix", noremap = true, silent = true }
)
vim.keymap.set(
	{ "n", "v" },
	"<leader>cv",
	"<cmd>CodeCompanion /commit<cr>",
	{ desc = "[C]odeCompanion [V]CS Commit Message", noremap = true, silent = true }
)
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
