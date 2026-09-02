-- Fast on-screen motion
vim.pack.add {
  'https://github.com/smoka7/hop.nvim',
  -- leap.nvim moved off GitHub; github.com/ggandor/leap.nvim was emptied by the author
  'https://codeberg.org/andyg/leap.nvim',
}

require('hop').setup { keys = 'etovxqpdygfblzhckisuran', term_seq_bias = 0.5 }
require('leap').add_default_mappings()
