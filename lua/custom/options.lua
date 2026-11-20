vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.guicursor:append('t:block-blinkon0') -- Disable cursor blinking in terminal mode

vim.opt.wrap = true
vim.opt.conceallevel = 2
vim.o.cmdheight = 2

-- Treesitter-based folding, but don't fold on file open
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldenable = false

-- Prefer the floating diagnostic window (see LspAttach `jump.on_jump`) over inline virtual text
vim.diagnostic.config { virtual_text = false }

-- Fix remote clipboard: copy goes to the local clipboard over OSC 52; paste returns the last thing
-- copied or deleted in Neovim (reading the clipboard back over OSC 52 hangs in many terminals)
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
  local osc52 = require 'vim.ui.clipboard.osc52'
  local cache = { ['+'] = { {}, 'v' }, ['*'] = { {}, 'v' } }
  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      cache[reg] = { lines, regtype }
      send(lines)
    end
  end
  local function paste(reg)
    return function() return cache[reg] end
  end
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = { ['+'] = copy '+', ['*'] = copy '*' },
    paste = { ['+'] = paste '+', ['*'] = paste '*' },
  }
end
