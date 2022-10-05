vim.cmd "highlight Normal guibg=none guifg=none"
vim.cmd "set mouse=r"
vim.cmd "autocmd CursorHold * silent! checktime"

-- vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- vim.diagnostic.open_float()

-- vim.diagnostic.config({
--   float = {
--     source = 'always',
--     border = 'rounded'
--   },
-- })

vim.g.mkdp_auto_start = 1
vim.g.mkdp_browser = 'firefox'

vim.opt.relativenumber = true
