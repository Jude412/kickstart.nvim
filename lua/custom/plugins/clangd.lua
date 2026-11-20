-- clangd sometimes needs utf-16 offset-encoding forced to play nicely with certain clients
vim.lsp.config('clangd', {
  cmd = { 'clangd', '--offset-encoding=utf-16' },
})
