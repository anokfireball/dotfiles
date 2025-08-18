return {
	{
		"saghen/blink.cmp",
		event = "InsertEnter",
		version = "1.*",
		dependencies = {
			"disrupted/blink-cmp-conventional-commits",
			"folke/lazydev.nvim",
			"moyiz/blink-emoji.nvim",
			{ "xzbdmw/colorful-menu.nvim", opts = {} },
		},
		opts = {
			keymap = {
				preset = "none",

				["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
				["<Esc>"] = { "cancel", "fallback" },

				["<C-b>"] = { "scroll_documentation_up" },
				["<C-f>"] = { "scroll_documentation_down" },

				["<C-k>"] = { "show_signature", "hide_signature" },
			},
			completion = {
				trigger = {
					show_on_keyword = false,
					show_on_trigger_character = true,
					show_on_insert_on_trigger_character = true,
					show_on_accept_on_trigger_character = true,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 1500,
				},
				menu = {
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", gap = 1 },
						},
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
					auto_show = true,
				},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				-- TODO does not work with copilot
                -- https://github.com/Saghen/blink.cmp/issues/1501 ?
                -- https://github.com/LazyVim/LazyVim/blob/25abbf546d564dc484cf903804661ba12de45507/lua/lazyvim/plugins/extras/ai/copilot.lua#L28-L40 ?
				ghost_text = {
					enabled = vim.b.copilot_suggestion_hidden,
					show_with_menu = true,
					show_without_menu = true,
					show_with_selection = true,
					show_without_selection = true,
				},
			},
			signature = {
				enabled = true,
			},
			fuzzy = {
				implementation = "prefer_rust_with_warning",
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
					lua = {
						inherit_defaults = true,
						"lazydev",
					},
					gitcommit = {
						"conventional_commits",
						"emoji",
					},
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
	},
}
