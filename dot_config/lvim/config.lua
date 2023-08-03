vim.g.clipboard = {
	name = "win32yank",
	copy = {
		["+"] = "win32yank.exe -i --crlf",
		["*"] = "win32yank.exe -i --crlf",
	},
	paste = {
		["+"] = "win32yank.exe -o --lf",
		["*"] = "win32yank.exe -o --lf",
	},
	cache_enabled = 0,
}

-- general
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "kanagawa"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"

-- add your own keymapping
lvim.keys.normal_mode["<C-Space>"] = "ea"
lvim.keys.normal_mode["<C-s>"] = ":w<CR>"
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["Y"] = "y$"

-- Use which-key to add extra bindings with the leader-key prefix
lvim.builtin.which_key.mappings["b"]["c"] = { "<cmd>%bd <bar> e# <bar> bd# <CR>", "Close others" }
lvim.builtin.which_key.mappings["n"] = { "<cmd>Telescope neoclip<CR>", "Neoclip" }
lvim.builtin.which_key.mappings["t"] =
	{ "<cmd>lua require('dap-python').test_method({ console = 'internalConsole'})<CR>", "Test this" }
-- lvim.builtin.which_key.mappings["t"] = { "<cmd>lua require('dap-python').test_method({ console = 'integratedTerminal'})<CR>", "Test this" }
-- lvim.builtin.which_key.mappings["t"] = { "<cmd>lua require('dap-python').test_method({ console = 'externalTerminal'})<CR>", "Test this" }

-- Configure other core plugins
lvim.builtin.autopairs.active = false
lvim.builtin.dap.ui.config.layouts = {
	{
		elements = {
			{ id = "scopes", size = 0.50 },
			{ id = "stacks", size = 0.20 },
			{ id = "breakpoints", size = 0.15 },
			{ id = "watches", size = 0.15 },
		},
		size = 0.3,
		position = "right",
	},
	{
		elements = {
			{ id = "repl", size = 1.0 },
		},
		size = 0.3,
		position = "bottom",
	},
}
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = true

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
	"bash",
	"c",
	"javascript",
	"json",
	"lua",
	"python",
	"typescript",
	"tsx",
	"css",
	"rust",
	"java",
	"yaml",
}
lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- set a formatter, this will override the language server formatting capabilities (if it exists)
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ command = "black", filetypes = { "python" } },
	{ command = "csharpier", filetypes = { "cs" } },
	{ command = "stylua", filetypes = { "lua" } },
})

-- fix php-cs-fixer
local null_ls = require("null-ls")
null_ls.register({
	null_ls.builtins.formatting.phpcsfixer.with({
		args = { "--rules=@PhpCsFixer", "--no-interaction", "--quiet", "fix", "$FILENAME" },
	}),
})

-- set additional linters
local linters = require("lvim.lsp.null-ls.linters")
linters.setup({
	{ command = "codespell" },
	{ command = "cspell", filetypes = { "md" } },
})

-- Additional Plugins
lvim.plugins = {
	-- Theme
	{ "rebelot/kanagawa.nvim" },
	-- LSP fidget - quick info what the LSP is doing
	{
		"j-hui/fidget.nvim",
		config = function()
			require("fidget").setup({})
		end,
	},
	-- Press tab in insert mode to escape from "" or {}
	{
		"abecodes/tabout.nvim",
		lazy = true,
		config = function()
			require("tabout").setup({
				tabkey = "<Tab>", -- key to trigger tabout, set to an empty string to disable
				backwards_tabkey = "<S-Tab>", -- key to trigger backwards tabout, set to an empty string to disable
				act_as_tab = true, -- shift content if tab out is not possible
				act_as_shift_tab = false, -- reverse shift content if tab out is not possible (if your keyboard/terminal supports <S-Tab>)
				default_tab = "<C-t>", -- shift default action (only at the beginning of a line, otherwise <TAB> is used)
				default_shift_tab = "<C-d>", -- reverse shift default action,
				enable_backwards = true, -- well ...
				completion = true, -- if the tabkey is used in a completion pum
				tabouts = {
					{ open = "'", close = "'" },
					{ open = '"', close = '"' },
					{ open = "`", close = "`" },
					{ open = "(", close = ")" },
					{ open = "[", close = "]" },
					{ open = "{", close = "}" },
				},
				ignore_beginning = true, --[[ if the cursor is at the beginning of a filled element it will rather tab out than shift the content ]]
				exclude = {}, -- tabout will ignore these filetypes
			})
		end,
	},
	-- Better text objects, support for functions and classes via Treesitter
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						-- Automatically jump forward to textobj, similar to targets.vim
						lookahead = true,
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							-- You can optionally set descriptions to the mappings (used in the desc parameter of
							-- nvim_buf_set_keymap) which plugins like which-key display
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
						},
						-- You can choose the select mode (default is charwise 'v')
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * method: eg 'v' or 'o'
						-- and should return the mode ('v', 'V', or '<c-v>') or a table
						-- mapping query_strings to modes.
						selection_modes = {
							["@parameter.outer"] = "v", -- charwise
							["@function.outer"] = "V", -- linewise
							["@class.outer"] = "<c-v>", -- blockwise
						},
						-- If you set this to `true` (default is `false`) then any textobject is
						-- extended to include preceding or succeeding whitespace. Succeeding
						-- whitespace has priority in order to act similarly to eg the built-in
						-- `ap`.
						--
						-- Can also be a function which gets passed a table with the keys
						-- * query_string: eg '@function.inner'
						-- * selection_mode: eg 'v'
						-- and should return true of false
						include_surrounding_whitespace = true,
					},
				},
			})
		end,
	},
	-- Support for camelCase, underscore_case, etc. in motions
	-- { 'chaoren/vim-wordmotion' },
	-- Support for variable text object (similar to above)
	{
		"Julian/vim-textobj-variable-segment",
		dependencies = { "kana/vim-textobj-user" },
	},
	-- Support for .editorconfig
	{ "gpanders/editorconfig.nvim" },
	-- Highlight arguments throughout the function
	{
		"m-demare/hlargs.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("hlargs").setup({
				highlight = { italic = true },
			})
		end,
		event = "VeryLazy",
	},
	-- Clipboard manager
	{
		"AckslD/nvim-neoclip.lua",
		lazy = true,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("neoclip").setup()
			require("telescope").load_extension("neoclip")
		end,
	},
	-- Highlight first letters for easier motion
	{
		"jinh0/eyeliner.nvim",
		config = function()
			require("eyeliner").setup({
				highlight_on_key = true,
			})
		end,
	},
	-- New motion 's' followed by two letters where you want to jump
	{
		"ggandor/lightspeed.nvim",
		event = "BufRead",
	},
	-- Python test debugging
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").setup()
			require("dap-python").test_runner = "pytest"
		end,
	},
	-- When opening a file, put cursor at the last place it was
	{
		"ethanholz/nvim-lastplace",
		event = "BufRead",
		config = function()
			require("nvim-lastplace").setup({
				lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
				lastplace_ignore_filetype = {
					"gitcommit",
					"gitrebase",
					"svn",
					"hgcommit",
				},
				lastplace_open_folds = true,
			})
		end,
	},
	-- Colorful comments
	{
		"folke/todo-comments.nvim",
		event = "BufRead",
		config = function()
			require("todo-comments").setup()
		end,
	},
	-- DAP autocompletion
	{
		"rcarriga/cmp-dap",
		config = function()
			require("cmp").setup({
				enabled = function()
					return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or require("cmp_dap").is_dap_buffer()
				end,
			})
			require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
				sources = {
					{ name = "dap" },
				},
			})
		end,
		event = "VeryLazy",
	},
	-- init.lua and plugin support
	{
		"folke/neodev.nvim",
		event = "VeryLazy",
	},
	-- show signature as you type
	-- {
	-- 	"ray-x/lsp_signature.nvim",
	-- 	dependencies = {
	-- 		"neovim/nvim-lspconfig",
	-- 	},
	-- 	config = function()
	-- 		require("lsp_signature").setup({})
	-- 	end,
	-- 	event = "VeryLazy",
	-- },
	-- remove old, untouched buffers
	{
		"chrisgrieser/nvim-early-retirement",
		config = true,
		event = "VeryLazy",
	},
}

-- Catch all unhandled exceptions
local dap = require("dap")
dap.listeners.after.event_initialized["dap_exception_breakpoint"] = function()
	dap.set_exception_breakpoints({ "userUnhandled" })
end
-- Automatically open dap-ui
dap.listeners.after.event_initialized["dapui_config"] = function()
	local dapui = require("dapui")
	dapui.open()
end
dap.listeners.after.event_terminated["dapui_config"] = function()
	local dapui = require("dapui")
	dapui.close()
end
dap.listeners.after.event_exited["dapui_config"] = function()
	local dapui = require("dapui")
	dapui.close()
end

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.json", "*.jsonc" },
	-- enable wrap mode for json files only
	command = "setlocal wrap",
})
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.py", "*.java" },
	-- load debbuging config from .vscode/launch.json
	command = "lua require('dap.ext.vscode').load_launchjs()",
})
vim.api.nvim_create_autocmd("FileType", {
	pattern = "zsh",
	callback = function()
		-- let treesitter use bash highlight for zsh files as well
		require("nvim-treesitter.highlight").attach(0, "bash")
	end,
})
