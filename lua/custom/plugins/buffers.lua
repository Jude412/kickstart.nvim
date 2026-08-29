vim.pack.add { 'https://github.com/akinsho/bufferline.nvim' }

require('bufferline').setup {}
require('mini.bufremove').setup {}

vim.keymap.set('n', '<leader>bn', '<cmd>BufferLineCycleNext<CR>', { desc = '[B]uffer [N]ext' })
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineCyclePrev<CR>', { desc = '[B]uffer [P]rev' })
vim.keymap.set('n', '<leader>bk', function() require('mini.bufremove').delete(0, false) end, { desc = '[B]uffer [K]ill' })
