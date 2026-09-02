vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.pack.add { 'https://github.com/nvim-tree/nvim-tree.lua' }
require('nvim-tree').setup {
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  on_attach = function(bufnr)
    local api = require 'nvim-tree.api'
    api.config.mappings.default_on_attach(bufnr)

    local opts = function(desc) return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true } end
    -- h/l aren't bound by nvim-tree's defaults anymore; restore the close/open behaviour
    vim.keymap.set('n', 'h', api.node.navigate.parent_close, opts 'Close Directory')
    vim.keymap.set('n', 'l', api.node.open.edit, opts 'Open')
  end,
}

vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file [E]xplorer' })
