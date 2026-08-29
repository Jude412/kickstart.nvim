-- Togglable terminal
vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }

require('toggleterm').setup {
  open_mapping = [[<c-\>]], -- handles count-prefix automatically: 2<C-\> opens/toggles terminal 2, bare <C-\> toggles the last-used one
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
}
