vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = true
vim.opt.conceallevel = 2
vim.o.cmdheight = 2

-- Treesitter-based folding, but don't fold on file open
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false

-- Prefer the floating diagnostic window (see LspAttach `jump.on_jump`) over inline virtual text
vim.diagnostic.config { virtual_text = false }

-- Fix remote clipboard
if vim.env.SSH_TTY and not (vim.env.DISPLAY or vim.env.WAYLAND_DISPLAY) then
  local osc52 = require 'vim.ui.clipboard.osc52'

  local cached = {}
  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      cached = { lines, regtype }
      send(lines)
    end
  end
  local function paste() return cached end

  vim.g.clipboard = {
    name = 'OSC 52',
    copy = { ['+'] = copy '+', ['*'] = copy '*' },
    paste = { ['+'] = paste, ['*'] = paste },
  }
end
