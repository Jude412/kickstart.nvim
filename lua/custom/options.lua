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
