vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>t', ':GoTest<CR>', {})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>c', ':GoCoverageToggle<CR>', {})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dt', ':lua require("dap-go").debug_test()<CR>', {})
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>dl', ':lua require("dap-go").debug_last_test()<CR>', {})

require('dap-go').setup {}
