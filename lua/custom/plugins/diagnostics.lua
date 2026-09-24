-- Alternative diagnostics display (native virtual_text is disabled in custom/options.lua)
vim.pack.add { 'https://github.com/casonadams/simple-diagnostics.nvim' }

require('simple-diagnostics').setup {
  virtual_text = true,
  message_area = true,
  signs = true,
}
