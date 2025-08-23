-- Secure SOPS integration for Neovim
-- Provides transparent encryption/decryption of SOPS files without ever writing plaintext to disk
-- All operations are performed in-memory using stdin/stdout pipes
-- Preserves SOPS metadata and unencrypted_regex rules

local M = {}

-- Configuration
local config = {
	-- File patterns that should be treated as SOPS files
	sops_patterns = {
		"%.sops%.ya?ml$",
		"%.sops%.json$",
		"%.sops%.toml$",
		"%.sops%.env$",
	},
	-- Verbose notifications
	verbose = false,
}

-- Store original encrypted content for metadata preservation
local sops_metadata = {}

local function is_sops_file(filepath)
	if not filepath or filepath == "" then
		return false
	end

	for _, pattern in ipairs(config.sops_patterns) do
		if filepath:match(pattern) then
			return true
		end
	end

	return false
end

-- Execute shell command and return success, stdout, stderr
local function execute_command(cmd, input)
	local exit_code
	local stdout

	if input then
		local result = vim.fn.system(cmd, input)
		exit_code = vim.v.shell_error
		stdout = result
	else
		local result_list = vim.fn.systemlist(cmd)
		exit_code = vim.v.shell_error
		stdout = table.concat(result_list, "\n")
	end

	if exit_code == 0 then
		return true, stdout, ""
	else
		return false, "", stdout
	end
end

local function handle_decrypt(args)
	-- Normalize path as absolute
	local filepath = vim.fn.fnamemodify(args.file, ":p")

	if not is_sops_file(filepath) then
		return
	end

	if vim.fn.filereadable(filepath) == 0 then
		return
	end

	if config.verbose then
		vim.notify("Decrypting SOPS file: " .. vim.fn.fnamemodify(filepath, ":~"), vim.log.levels.INFO)
	end

	-- Store original encrypted content for metadata preservation
	local original_content = {}
	local file = io.open(filepath, "r")
	if not file then
		vim.notify(
			string.format("sops-secure: Could not open %s for reading", vim.fn.fnamemodify(filepath, ":~")),
			vim.log.levels.ERROR
		)
		return
	end

	for line in file:lines() do
		table.insert(original_content, line)
	end
	file:close()
	sops_metadata[filepath] = original_content

	-- Decrypt file content using sops
	local cmd = string.format("sops -d %s", vim.fn.shellescape(filepath))
	local success, stdout, stderr = execute_command(cmd)

	if not success then
		vim.notify(
			string.format("SOPS decryption failed for %s:\n%s", vim.fn.fnamemodify(filepath, ":~"), stderr),
			vim.log.levels.ERROR
		)
		return
	end

	-- Set buffer to acwrite mode so we can intercept writes
	vim.bo[args.buf].buftype = "acwrite"
	vim.bo[args.buf].modifiable = true

	-- Harden the buffer to prevent Neovim from leaking plaintext to disk
	vim.bo[args.buf].swapfile = false
	vim.bo[args.buf].undofile = false

	-- Register buffer-local write command for this SOPS buffer only
	local buf_group = vim.api.nvim_create_augroup("SopsSecureBuf" .. args.buf, { clear = true })
	-- Use vim.schedule to ensure the reference is resolved after this function scope
	vim.api.nvim_create_autocmd("BufWriteCmd", {
		group = buf_group,
		buffer = args.buf,
		callback = function(ev)
			-- Build an explicit args table similar to autocmd callback format
			local b = (ev and ev.buf) or args.buf
			vim.schedule(function()
				require("sops_secure")._encrypt({ buf = b })
			end)
		end,
		desc = "Encrypt SOPS buffer on write",
	})

	-- Replace buffer content with decrypted data
	local lines = vim.split(stdout, "\n")
	vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
	vim.bo[args.buf].modified = false

	if config.verbose then
		vim.notify("SOPS file decrypted successfully", vim.log.levels.INFO)
	end
end

local function handle_encrypt(args)
	if not args or not args.buf then
		return
	end
	-- Normalize path as absolute
	local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":p")

	-- Only handle acwrite buffers (our SOPS files)
	if vim.bo[args.buf].buftype ~= "acwrite" then
		return
	end

	-- Avoid MAC and timestamp updates if no changes were made
	if not vim.bo[args.buf].modified then
		if config.verbose then
			vim.notify("No changes to save for: " .. vim.fn.fnamemodify(filepath, ":~"), vim.log.levels.INFO)
		end
		return
	end

	if config.verbose then
		vim.notify("Encrypting SOPS file: " .. vim.fn.fnamemodify(filepath, ":~"), vim.log.levels.INFO)
	end

	-- Reconstruct the entire file plaintext directly from buffer
	local buffer_lines = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
	local full_plaintext = table.concat(buffer_lines, "\n") .. "\n"

	if config.verbose then
		vim.notify("Encrypting entire file", vim.log.levels.INFO)
	end

	-- Encrypt the entire file using metadata from original file
	local cmd = string.format(
		"printf %%s %s | sops --encrypt --filename-override %s /dev/stdin",
		vim.fn.shellescape(full_plaintext),
		vim.fn.shellescape(filepath)
	)
	local success, encrypted_output, stderr = execute_command(cmd)

	if not success then
		vim.notify(
			string.format(
				"SOPS encryption failed for %s:\nCommand: %s\nError: %s",
				vim.fn.fnamemodify(filepath, ":~"),
				cmd,
				stderr
			),
			vim.log.levels.ERROR
		)
		return
	end

	-- Write encrypted content to file
	local file = io.open(filepath, "w")
	if not file then
		vim.notify(
			string.format("Error: Could not write to %s", vim.fn.fnamemodify(filepath, ":~")),
			vim.log.levels.ERROR
		)
		return
	end

	file:write(encrypted_output)
	file:close()

	-- Mark buffer as not modified
	vim.bo[args.buf].modified = false

	if config.verbose then
		vim.notify("SOPS file encrypted and saved successfully", vim.log.levels.INFO)
	end
end

-- Setup function to initialize the plugin
function M.setup(opts)
	opts = opts or {}

	-- Merge user config with defaults
	config = vim.tbl_deep_extend("force", config, opts)

	-- Dependency check
	if vim.fn.executable("sops") == 0 then
		vim.notify("sops-secure: `sops` binary not found in $PATH. Plugin disabled.", vim.log.levels.ERROR)
		return
	end

	-- Create autocommand group
	local group = vim.api.nvim_create_augroup("SopsSecure", { clear = true })

	-- Decrypt on file read
	vim.api.nvim_create_autocmd("BufReadPost", {
		group = group,
		pattern = "*",
		callback = handle_decrypt,
		desc = "Decrypt SOPS files on read",
	})

	-- Clean up metadata on buffer close
	vim.api.nvim_create_autocmd("BufWipeout", {
		group = group,
		pattern = "*",
		callback = function(args)
			-- Normalize path as absolute
			local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(args.buf), ":p")
			if sops_metadata[filepath] then
				sops_metadata[filepath] = nil
			end
		end,
		desc = "Clean up SOPS metadata on buffer close",
	})

	if config.verbose then
		vim.notify("sops-secure: plugin loaded", vim.log.levels.INFO)
	end
end

-- expose internal for autocmd wrapper
M._encrypt = handle_encrypt

return M
