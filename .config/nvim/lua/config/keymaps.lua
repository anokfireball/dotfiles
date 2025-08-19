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
-- window resizing analogous to tmux
vim.keymap.set("n", "<C-Up>", "<cmd>resize +1<CR>", { desc = "Increase window height by 1" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -1<CR>", { desc = "Decrease window height by 1" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -1<CR>", { desc = "Decrease window width by 1" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +1<CR>", { desc = "Increase window width by 1" })
-- Smart Right key for insert mode (Blink vs Copilot)
vim.keymap.set("i", "<Right>", function()
	if require("blink.cmp").is_visible() then
		return require("blink.cmp").accept()
	else
		return require("copilot.suggestion").accept()
	end
end, { expr = true, desc = "Accept completion/suggestion" })
vim.keymap.set("i", "<Down>", function()
	if require("blink.cmp").is_visible() then
		return require("blink.cmp").select_next()
	else
		return require("copilot.suggestion").next()
	end
end, { expr = true, desc = "Next completion/suggestion" })
vim.keymap.set("i", "<Up>", function()
	if require("blink.cmp").is_visible() then
		return require("blink.cmp").select_prev()
	else
		return require("copilot.suggestion").prev()
	end
end, { expr = true, desc = "Previous completion/suggestion" })

-- Unmap arrow keys
vim.keymap.set("n", "<Up>", "<Nop>", { desc = "Disable Up Arrow" })
vim.keymap.set("n", "<Down>", "<Nop>", { desc = "Disable Down Arrow" })
vim.keymap.set("n", "<Left>", "<Nop>", { desc = "Disable Left Arrow" })
vim.keymap.set("n", "<Right>", "<Nop>", { desc = "Disable Right Arrow" })

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
local function map_telescope(lhs, func, desc, opts)
	vim.keymap.set("n", lhs, function()
		require("telescope.builtin")[func](opts)
	end, { desc = desc })
end
map_telescope("<leader>f/", "current_buffer_fuzzy_find", "[F]ind in Current Buffer", { skip_empty_lines = true })
map_telescope("<leader>f;", "resume", "[F]ind Resume")
map_telescope("<leader>fb", "buffers", "[F]ind [B]uffers", { ignore_current_buffer = true, sort_mru = true })
map_telescope("<leader>fd", "git_files", "[F]ind [D]otfiles", { cwd = "~" })
map_telescope("<leader>ff", "find_files", "[F]ind [F]iles")
map_telescope("<leader>fF", "find_files", "[F]ind [F]iles (/w ignored)", { no_ignore = true, hidden = true })
map_telescope("<leader>fg", "live_grep", "[F]ind by [G]rep (cwd)")
map_telescope("<leader>fG", "live_grep", "[F]ind by [G]rep (open files)", { grep_open_files = true })
map_telescope("<leader>fh", "help_tags", "[F]ind [H]elp")
map_telescope("<leader>fk", "keymaps", "[F]ind [K]eymaps")
vim.keymap.set("n", "<leader>fn", function()
	vim.cmd("Telescope notify")
end, { desc = "[F]ind [N]otifications" })
map_telescope("<leader>fr", "oldfiles", "[F]ind [R]ecent Files")
map_telescope("<leader>ft", "builtin", "[F]ind [T]elescope Builtins")
map_telescope("<leader>fw", "grep_string", "[F]ind current [W]ord (cwd)")
map_telescope("<leader>fW", "grep_string", "[F]ind current [W]ord (open files)", { grep_open_files = true })

-- Toggles
vim.keymap.set("n", "<leader>nd", function()
	require("notify").dismiss()
end, { desc = "[N]otification [D]ismiss" })
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
	require("copilot")
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
vim.keymap.set({ "n", "v" }, "<leader>vl", function()
	vim.cmd("GitPortal copy_link_to_clipboard")
end, { desc = "[V]CS Copy [L]ink To Clipboard" })
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

local function get_session_list()
	local sessions = require("mini.sessions").detected
	local session_list = {}

	for name, data in pairs(sessions) do
		table.insert(session_list, {
			name = name,
			path = data.path,
			type = data.type,
			modify_time = data.modify_time,
		})
	end

	-- Sort by most recently modified
	table.sort(session_list, function(a, b)
		return a.modify_time > b.modify_time
	end)

	return session_list
end

local function session_entry_maker(entry)
	return {
		value = entry,
		display = entry.name .. " (" .. entry.type .. ")",
		ordinal = entry.name,
	}
end

local function handle_session_selection(action)
	return function()
		local selection = require("telescope.actions.state").get_selected_entry()
		require("telescope.actions").close()

		if not selection then
			return
		end

		local session_name = selection.value.name

		if action == "read" then
			require("mini.sessions").read(session_name)
		elseif action == "delete" then
			local confirm = vim.fn.input("Delete session '" .. session_name .. "'? (y/N): ")
			if confirm:lower() == "y" or confirm:lower() == "yes" then
				require("mini.sessions").delete(session_name)
			end
		end
	end
end

local function create_session_picker(action, title)
	return function()
		local session_list = get_session_list()

		if #session_list == 0 then
			vim.notify("No sessions found", vim.log.levels.INFO)
			return
		end

		require("telescope.pickers")
			.new({}, {
				prompt_title = title,
				finder = require("telescope.finders").new_table({
					results = session_list,
					entry_maker = session_entry_maker,
				}),
				sorter = require("telescope.sorters").get_generic_fuzzy_sorter(),
				attach_mappings = function(prompt_bufnr, _)
					require("telescope.actions").select_default:replace(handle_session_selection(action))
					return true
				end,
			})
			:find()
	end
end

local function save_session_with_prompt()
	local name = vim.fn.input("Save session as: ")
	if name and name ~= "" then
		require("mini.sessions").write(name, { force = true })
	end
end

-- Session keymaps
vim.keymap.set("n", "<leader>ss", save_session_with_prompt, { desc = "[S]ession [S]ave" })
vim.keymap.set("n", "<leader>sl", create_session_picker("read", "Load Session"), { desc = "[S]ession [L]oad" })
vim.keymap.set("n", "<leader>sd", create_session_picker("delete", "Delete Session"), { desc = "[S]ession [D]elete" })

-- Folding keymaps (nvim-ufo)
vim.keymap.set("n", "zR", function()
	require("ufo").openAllFolds()
end, { desc = "Open all folds" })
vim.keymap.set("n", "zM", function()
	require("ufo").closeAllFolds()
end, { desc = "Close all folds" })
vim.keymap.set("n", "zr", function()
	require("ufo").openFoldsExceptKinds()
end, { desc = "Open folds except kinds" })
vim.keymap.set("n", "zm", function()
	require("ufo").closeFoldsWith()
end, { desc = "Close folds with kind" })
