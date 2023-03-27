vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>t', ':GoTest<CR>', {})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>c', ':GoCoverageToggle<CR>', {})
