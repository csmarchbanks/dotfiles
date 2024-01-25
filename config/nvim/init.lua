-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = nil
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	packer_bootstrap = vim.fn.system({
		'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path,
	})
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost',
	{ command = 'source <afile> | PackerCompile', group = packer_group, pattern = 'init.lua' })

require('packer').startup(function(use)
	use 'wbthomason/packer.nvim' -- Package manager
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
	use "rebelot/kanagawa.nvim"
	use 'tpope/vim-fugitive' -- Git commands in nvim
	-- UI to select things (files, grep results, open buffers...)
	use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }
	use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}
	use 'nvim-treesitter/nvim-treesitter-textobjects'
	use 'airblade/vim-gitgutter'
	use 'hrsh7th/nvim-cmp' -- Autocompletion plugin
	use 'hrsh7th/cmp-nvim-lsp'
	use 'saadparwaiz1/cmp_luasnip'
	use 'L3MON4D3/LuaSnip' -- Snippets plugin
	use 'akinsho/bufferline.nvim'
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true }
	}
	use 'fatih/vim-go'
	use 'google/vim-jsonnet'
	use 'hashivim/vim-terraform'
	use 'psf/black'

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require('packer').sync()
	end
end)

-- Set highlight on search
vim.o.hlsearch = false
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.cmd("colorscheme kanagawa")

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Map comma as the leader key
vim.g.mapleader = ','

-- Bufferline config
vim.opt.termguicolors = true
require("bufferline").setup{}

-- Lualine config
require('lualine').setup{}

vim.opt.termguicolors = true
require("bufferline").setup{}
-- quickfix shortcuts
vim.api.nvim_set_keymap('n', '<C-j>', ':cnext<CR>', {})
vim.api.nvim_set_keymap('n', '<C-k>', ':cprevious<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>a', ':cclose<CR>', {})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist)

-- Per-language settings
vim.api.nvim_command [[
autocmd FileType rust setlocal tabstop=4|set expandtab|set shiftwidth=4
autocmd FileType python setlocal tabstop=4|set expandtab|set shiftwidth=4
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType make setlocal noexpandtab
autocmd FileType tex setlocal spell
autocmd FileType text setlocal noexpandtab
]]

-- LSP settings
require("mason").setup()
require("mason-lspconfig").setup({
	automatic_installation = true,
})

local lspconfig = require 'lspconfig'
local on_attach = function(_, bufnr)
	local opts = { buffer = bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
	vim.keymap.set('n', '<A-k>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('i', '<A-k>', vim.lsp.buf.signature_help, opts)
	vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
	vim.keymap.set('n', '<leader>wl', function()
		vim.inspect(vim.lsp.buf.list_workspace_folders())
	end, opts)
	vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
	vim.keymap.set('n', '<leader>so', require('telescope.builtin').lsp_document_symbols, opts)
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'clangd', 'gopls', 'jsonls', 'jsonnet_ls', 'rust_analyzer', 'terraformls', 'tsserver' }
for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup {
		on_attach = on_attach,
		capabilities = capabilities,
	}
end

local util = require 'lspconfig/util'
local path = util.path

-- Enable lua language server with custom settings.
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

lspconfig.lua_ls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file('', true),
			},
			-- Do not send telemetry data containing a randomized but unique identifier
			telemetry = {
				enable = false,
			},
		},
	},
}

-- Enable python separately as it needs a before_init to find the python path.
local function get_python_path(workspace)
	-- Use activated virtualenv.
	if vim.env.VIRTUAL_ENV then
		local py = path.join(vim.env.VIRTUAL_ENV, 'bin', 'python')
		--print('Using virtualenv Python in ' .. py)
		return py
	end

	-- Find and use virtualenv in workspace directory.
	for _, pattern in ipairs({ '*', '.*' }) do
		local match = vim.fn.glob(path.join(workspace, pattern, 'pyproject.toml'))
		if match ~= '' then
			--print('Found pyproject.toml at ' .. match)
			local dir = match:match("(.*[/\\])")
			local command = 'cd ' .. dir .. ' && poetry env list --full-path --no-ansi'
			--print('Running: ' .. command)
			local file = io.popen(command, 'r')
			local output = file:read("*a")
			--print('output: ' .. output)
			file:close()
			-- Remove trailing newline
			output = output:match '^%s*(%S*)'
			local py = path.join(output, 'bin', 'python')
			--print('Using Poetry Python at ' .. py)
			return py
		end
	end

	-- Fallback to system Python.
	--print('Using system python')
	return 'python3'
end

lspconfig.pyright.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	before_init = function(_, config)
		config.settings.python.pythonPath = get_python_path(config.root_dir)
	end,
	settings = {
		analysis = {
			autoImportCompletions = true,
		},
	}
}

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
		},
		['<Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { 'i', 's' }),
		['<S-Tab>'] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { 'i', 's' }),
	}),
	sources = {
		{ name = 'nvim_lsp' },
	},
}

-- Telescope
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				['<C-u>'] = false,
				['<C-d>'] = false,
			},
		},
	},
}

-- Enable telescope fzf native
require('telescope').load_extension 'fzf'

--Add leader shortcuts
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
vim.keymap.set('n', '<leader>sf', function()
	require('telescope.builtin').find_files { previewer = false }
end)
vim.keymap.set('n', '<C-p>', function()
	require('telescope.builtin').find_files { previewer = false }
end)
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags)
vim.keymap.set('n', '<leader>st', require('telescope.builtin').tags)
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').grep_string)
vim.keymap.set('n', '<leader>sp', require('telescope.builtin').live_grep)
vim.keymap.set('n', '<leader>so', function()
	require('telescope.builtin').tags { only_current_buffer = true }
end)
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles)

-- Treesitter config
require "nvim-treesitter.configs".setup {
	ensure_installed = { "c", "cpp", "go", "lua", "rust", "typescript" },

	incremental_selection = {
		enable = true,
		keymaps = {
			-- mappings for incremental selection (visual mappings)
			init_selection = "gnn", -- maps in normal mode to init the node/scope selection
			node_incremental = "grn", -- increment to the upper named parent scope_incremental = "grc", -- increment to the upper scope (as defined in locals.scm)
			node_decremental = "grm" -- decrement to the previous node
		}
	},

	textobjects = {
		-- syntax-aware textobjects
		enable = true,
		lsp_interop = {
			enable = true,
			peek_definition_code = {
				["DF"] = "@function.outer",
				["DF"] = "@class.outer"
			}
		},
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["aC"] = "@class.outer",
			["iC"] = "@class.inner",
			["ac"] = "@conditional.outer",
			["ic"] = "@conditional.inner",
			["ae"] = "@block.outer",
			["ie"] = "@block.inner",
			["al"] = "@loop.outer",
			["il"] = "@loop.inner",
			["is"] = "@statement.inner",
			["as"] = "@statement.outer",
			["ad"] = "@comment.outer",
			["am"] = "@call.outer",
			["im"] = "@call.inner"
		},
		move = {
			enable = true,
			set_jumps = true, -- whether to set jumps in the jumplist
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer"
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer"
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer"
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer"
			}
		},
		select = {
			enable = true,
			keymaps = {
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			}
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>sw"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>SW"] = "@parameter.inner",
				["<leader>Sw"] = "@parameter.inner",
			}
		}
	}
}
