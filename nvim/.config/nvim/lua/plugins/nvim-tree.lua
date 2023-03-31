local status_nvim_tree, nvim_tree = pcall(require, "nvim-tree")
if not status_nvim_tree then
	print("nvim-tree not found")
	return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- empty setup using defaults
nvim_tree.setup({
	auto_reload_on_write = false,
	disable_netrw = false,
	hijack_cursor = false,
	hijack_netrw = true,
	hijack_unnamed_buffer_when_opening = true,
	ignore_buffer_on_setup = false,
	sort_by = "name",
	root_dirs = {},
	prefer_startup_root = false,
	reload_on_bufenter = false,
	on_attach = "enable",
	remove_keymaps = false, --x
	select_prompts = true, --x
	sync_root_with_cwd = true, --x
	respect_buf_cwd = false,
	view = {
		adaptive_size = false,
		centralize_selection = false,
		width = 30,
		hide_root_folder = false,
		side = "left",
		preserve_window_proportions = false,
		number = false,
		relativenumber = false,
		signcolumn = "yes",
		mappings = {
			custom_only = false,
			list = {
				{ key = "v", action = "vsplit" },
				{ key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
				{ key = "h", action = "close_node" },
			},
		},
		float = {
			enable = false,
			quit_on_focus_loss = true,
			open_win_config = {
				relative = "editor",
				border = "rounded",
				width = 30,
				height = 30,
				row = 1,
				col = 1,
			},
		},
	},
	renderer = {
		add_trailing = false,
		group_empty = false,
		highlight_git = true,
		full_name = false,
		highlight_opened_files = "none",
		root_folder_label = ":t",
		indent_width = 2,
		indent_markers = {
			enable = true,
			inline_arrows = true,
			icons = {
				corner = "└",
				edge = "│",
				item = "│",
				none = " ",
			},
		},
		icons = {
			git_placement = "after",
			padding = " ",
			symlink_arrow = " ➛ ",
			glyphs = {
				default = "",
				symlink = "",
				folder = {
					arrow_open = "",
					arrow_closed = "",
					default = "",
					open = "",
					empty = "",
					empty_open = "",
					symlink = "",
					symlink_open = "",
				},
				git = {
					unstaged = "",
					staged = "S",
					unmerged = "",
					renamed = "➜",
					untracked = "U",
					deleted = "",
					ignored = "◌",
				},
			},
		},
		special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
		symlink_destination = true,
	},
	hijack_directories = {
		enable = false,
		auto_open = true,
	},
	update_focused_file = {
		enable = true,
		debounce_delay = 15,
		update_root = true,
		ignore_list = {},
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	filters = {
		dotfiles = false,
		git_clean = false,
		no_buffer = false,
		custom = { "node_modules", "\\.cache", "^.git$", "obj", ".DS_Store" },
		exclude = {},
	},
	filesystem_watchers = {
		enable = true,
		debounce_delay = 50,
		ignore_dirs = {},
	},
	git = {
		enable = true,
		ignore = false,
		show_on_dirs = true,
		show_on_open_dirs = true,
		timeout = 200,
	},
	actions = {
		use_system_clipboard = true,
		change_dir = {
			enable = true,
			global = false,
			restrict_above_cwd = false,
		},
		expand_all = {
			max_folder_discovery = 300,
			exclude = {},
		},
		file_popup = {
			open_win_config = {
				col = 1,
				row = 1,
				relative = "cursor",
				border = "shadow",
				style = "minimal",
			},
		},
		open_file = {
			quit_on_open = false,
			resize_window = false,
			window_picker = {
				enable = true,
				picker = "default",
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = { "notify", "lazy", "qf", "diff", "fugitive", "fugitiveblame" },
					buftype = { "nofile", "terminal", "help" },
				},
			},
		},
		remove_file = {
			close_window = true,
		},
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
	live_filter = {
		prefix = "[FILTER]: ",
		always_show_folders = true,
	},
	tab = {
		sync = {
			open = false,
			close = false,
			ignore = {},
		},
	},
	notify = {
		threshold = vim.log.levels.INFO,
	},
	log = {
		enable = false,
		truncate = false,
		types = {
			all = false,
			config = false,
			copy_paste = false,
			dev = false,
			diagnostics = false,
			git = false,
			profile = false,
			watcher = false,
		},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
})

-- open nvim-tree for neovim setup
local function open_nvim_tree_better(data)
	-- buffer is a real file on the disk
	local real_file = vim.fn.filereadable(data.file) == 1
	-- buffer is a [No Name]
	local no_name = data.data.file == "" and vim.bo[data.buf].buftype == ""

	if not real_file and not no_name then
		return
	end
	require("nvim-tree.api").tree.open({ focus = false, find_file = true })
end

-- open nvim-tree for neovim setup
local function open_nvim_tree()
	require("nvim-tree.api").tree.open({ focus = false, find_file = true })
end

-- set auto cmd to the VimEnter event
-- Version 1:
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
-- Version 2:
-- vim.api.nvim_create_autocmd({ "VimEnter" }, {
-- 	callback = function(data)
-- 		open_nvim_tree_better(data)
-- 	end,
-- })

-- Automatically open file upen createtion
local api = require("nvim-tree.api")
api.events.subscribe(api.events.Event.FileCreated, function(file)
	vim.cmd("edit " .. file.fname)
end)
