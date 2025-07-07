return {
	"saghen/blink.cmp",
	event = "VimEnter",
	version = "1.*",
	dependencies = {
		"folke/lazydev.nvim",
		"moyiz/blink-emoji.nvim",
		"disrupted/blink-cmp-conventional-commits",
	},
	opts = {
		keymap = { preset = "super-tab" },
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 1500 },
		},
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			-- Always prioritize exact matches
			sorts = {
				"exact",
				"score",
				"sort_text",
			},
		},
		sources = {
			default = {
				"lsp",
				"buffer",
				"snippets",
				"path",
				"emoji",
			},
			per_filetype = {
				lua = { inherit_defaults = true, "lazydev" },
				gitcommit = { "conventional_commits", "emoji" },
			},
			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},
				emoji = {
					name = "Emoji",
					module = "blink-emoji",
				},
				conventional_commits = {
					name = "Conventional Commits",
					module = "blink-cmp-conventional-commits",
				},
			},
		},
	},
}
