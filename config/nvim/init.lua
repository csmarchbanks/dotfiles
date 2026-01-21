-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = ','

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

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- Default tab options
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

require('lazy').setup({
	spec = {
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {"gopls", "lua_ls", "jsonls", "jsonnet_ls", "terraformls", "ts_ls", "rust_analyzer", "clangd"},
				automatic_installation = true,
				automatic_enable = false,
			},
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"neovim/nvim-lspconfig",
			},
		},
		{
			"rebelot/kanagawa.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				vim.cmd("colorscheme kanagawa")
			end
		},
		{ 'tpope/vim-fugitive' }, -- Git commands in nvim
		-- UI to select things (files, grep results, open buffers...)
		{
			'nvim-telescope/telescope.nvim',
			version = '*',
			dependencies = {
				'nvim-lua/plenary.nvim',
				-- optional but recommended
				{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
			},
			config = function()
				local builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers)
				vim.keymap.set('n', '<C-p>', function()
					   require('telescope.builtin').find_files { previewer = false }
				end)
				vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
				vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
				vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
				vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
				vim.keymap.set('n', '<leader>?', builtin.oldfiles)
				vim.keymap.set('n', '<leader>so', builtin.lsp_document_symbols)
			end
		},
		{
			'nvim-treesitter/nvim-treesitter',
			lazy = false,
			build = ':TSUpdate',
			main = 'nvim-treesitter.config',
			opts = {
				ensure_installed = { "c", "cpp", "go", "lua", "rust",
			"typescript" },
				auto_install = true,
			}
		},
		{ 'airblade/vim-gitgutter' },
		{ 'hrsh7th/nvim-cmp' },
		{ 'hrsh7th/cmp-nvim-lsp' },
		{ 'saadparwaiz1/cmp_luasnip' },
		{ 'L3MON4D3/LuaSnip' },
		{
			'nvim-lualine/lualine.nvim',
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			opts = {
				sections = {
					lualine_c = {
						{
							'filename',
							path = 1,
						}
					}
				},
				tabline = {
					lualine_a = {
						{
							'buffers',
							mode = 4,
						},
					},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = { 'lsp_status' }
				},
			},
		},
		{ 'fatih/vim-go' },
		{ 'google/vim-jsonnet' },
		{ 'hashivim/vim-terraform' },
		{ 'psf/black' },
		{ 'mfussenegger/nvim-dap' },
		{ 'leoluz/nvim-dap-go' },
		{ 'theHamsta/nvim-dap-virtual-text' },
		{
			'numToStr/Comment.nvim',
			opts = {},
		},
	},
	install = {
		missing = true,
	},
	checker = { enabled = true },
})


-- dap shortcuts
require("nvim-dap-virtual-text").setup()
vim.api.nvim_set_keymap('n', '<leader>db', ':lua require"dap".toggle_breakpoint()<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>dc', ':lua require"dap".continue()<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>di', ':lua require"dap".step_into()<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>do', ':lua require"dap".step_over()<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>dv', ':lua require"dap".repl.open()<CR>', {})

-- quickfix shortcuts
vim.api.nvim_set_keymap('n', '<C-j>', ':cnext<CR>', {})
vim.api.nvim_set_keymap('n', '<C-k>', ':cprevious<CR>', {})
vim.api.nvim_set_keymap('n', '<leader>a', ':cclose<CR>', {})

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setqflist)

-- LSP settings
vim.lsp.set_log_level("off")

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
end

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Enable the following language servers
local servers = { 'gopls', 'jsonls', 'jsonnet_ls', 'terraformls', 'ts_ls' }
for _, lsp in ipairs(servers) do
	vim.lsp.config(lsp, {
		on_attach = on_attach,
		capabilities = capabilities,
	})
end
vim.lsp.enable(servers)

vim.lsp.config("rust_analyzer", {
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
        ['rust-analyzer'] = {
            check = {
                command = "clippy";
            },
            diagnostics = {
                enable = true;
            }
        }
    }
})
vim.lsp.enable("rust_analyzer")

vim.lsp.config("clangd", {
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--completion-style=detailed",
		"--enable-config",
		"--fallback-style=llvm",
		"--function-arg-placeholders",
		"--header-insertion=iwyu",
		"--all-scopes-completion",
	},
})
vim.lsp.enable("clangd")

local util = require 'lspconfig/util'
local path = util.path

-- Enable lua language server with custom settings.
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

vim.lsp.config("lua_ls", {
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
})
vim.lsp.enable("lua_ls")

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
		local match = vim.fn.glob(path.join(workspace, pattern, 'uv.lock'))
		if match ~= '' then
			-- print('Found uv.lock at ' .. match)
			local dir = match:match("(.*)[/\\]uv.lock")
			local py = path.join(dir, '.venv', 'bin', 'python')
			-- print('Using uv Python at ' .. py)
			return py
		end

		local match = vim.fn.glob(path.join(workspace, pattern, 'poetry.lock'))
		if match ~= '' then
			-- print('Found poetry.lock at ' .. match)
			local dir = match:match("(.*[/\\])")
			local command = 'cd ' .. dir .. ' && poetry env list --full-path --no-ansi'
			-- print('Running: ' .. command)
			local file = io.popen(command, 'r')
			local output = file:read("*a")
			-- print('output: ' .. output)
			file:close()
			-- Remove trailing newline
			output = output:match '^%s*(%S*)'
			local py = path.join(output, 'bin', 'python')
			-- print('Using Poetry Python at ' .. py)
			return py
		end
	end

	-- Fallback to system Python.
	-- print('Using system python')
	return 'python3'
end

vim.lsp.config("pyright", {
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
})
vim.lsp.enable("pyright")

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
