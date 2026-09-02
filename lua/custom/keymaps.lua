-- Exit insert mode quickly
vim.keymap.set('i', 'jj', '<Esc>')

-- Split the line under the cursor (the opposite of `J`)
-- NOTE: intentionally overrides Neovim's default `K` (LSP hover)
vim.keymap.set('n', 'K', 'i<CR><Esc>')

-- Accept the first spelling suggestion for the word under the cursor
vim.keymap.set('n', 'zn', 'z=1<CR><CR>')

-- Free up `<leader><leader>` (init.lua's default duplicated `<leader>bf` from custom/plugins/buffers.lua)
vim.keymap.del('n', '<leader><leader>')
