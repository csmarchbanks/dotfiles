-- -- setup nvim-go
require('go').setup({
	auto_format = true,
	auto_lint = true,
	linter = 'golangci-lint',
	lint_prompt_style = 'vt',
	formatter = 'goimports',
	test_popup_auto_leave = true,
})

vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>t', ':GoTest<CR>', {})
