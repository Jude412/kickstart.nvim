vim.pack.add {
  { src = 'https://github.com/lervag/vimtex', version = 'v2.15' },
}

vim.g.vimtex_fold_enabled = 1
vim.g.vimtex_view_method = 'zathura'
vim.g.vimtex_callback_progpath = vim.v.progpath
vim.g.vimtex_compiler_latexmk = {
  options = { '-shell-escape', '-verbose', '-file-line-error', '-synctex=1', '-interaction=nonstopmode' },
}

vim.g.vimtex_quickfix_ignore_filters = { 'Overfull \\hbox', 'Underfull \\hbox' }
vim.g.vimtex_quickfix_open_on_warning = 0
