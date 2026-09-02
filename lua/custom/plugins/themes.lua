vim.pack.add {
  'https://github.com/LunarVim/onedarker.nvim',
  'https://github.com/neanias/everforest-nvim',
}
-- to switch: vim.cmd.colorscheme 'onedarker'

require('everforest').setup {
  on_highlights = function(hl, palette) hl.Conceal = { fg = palette.none, bg = palette.none, sp = palette.none } end,
}

-- Overrides the 'tokyonight-night' default set in init.lua
vim.cmd.colorscheme 'everforest'
