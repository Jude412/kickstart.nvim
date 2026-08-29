vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add { 'https://github.com/nvim-tree/nvim-tree.lua' }
require('nvim-tree').setup {}

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file [E]xplorer' })
