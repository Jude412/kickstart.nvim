-- Togglable terminal
vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }

require('toggleterm').setup {
  open_mapping = [[<c-\>]], -- handles count-prefix automatically: 2<C-\> opens/toggles terminal 2, bare <C-\> toggles the last-used one
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
}
vim.keymap.set('t', '<C-l>', '<cmd>ToggleTermNext<CR>', { desc = 'Next terminal' })
vim.keymap.set('t', '<C-h>', '<cmd>ToggleTermPrev<CR>', { desc = 'Previous terminal' })
vim.keymap.set('t', '<C-k>', '<cmd>ToggleTermToggleAll<CR>', { desc = 'All terminals' })
