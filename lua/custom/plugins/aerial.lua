-- Code outline / symbol navigation
vim.pack.add { 'https://github.com/stevearc/aerial.nvim' }

require('aerial').setup {
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
}

require('telescope').load_extension 'aerial'
require('telescope').setup {
  extensions = {
    aerial = {
      col1_width = 4,
      col2_width = 30,
      format_symbol = function(symbol_path, filetype)
        if filetype == 'json' or filetype == 'yaml' then
          return table.concat(symbol_path, '.')
        else
          return symbol_path[#symbol_path]
        end
      end,
      show_columns = 'both',
    },
  },
}

vim.keymap.set('n', '<leader>a', function() require('telescope').extensions.aerial.aerial() end, { desc = '[A]erial symbols' })
