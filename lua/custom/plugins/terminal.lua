-- Togglable terminal
vim.pack.add { 'https://github.com/akinsho/toggleterm.nvim' }

require('toggleterm').setup {
  open_mapping = [[<c-\>]], -- handles count-prefix automatically: 2<C-\> opens/toggles terminal 2, bare <C-\> toggles the last-used one
  direction = 'float',
  float_opts = {
    border = 'curved',
  },
  -- Subtle [i/n] in the bottom-right of the float border so you can tell which
  -- terminal is showing. Recomputed on every open, since n changes as
  -- terminals are created and exit. Hidden terminals (lazygit) are skipped.
  on_open = function(term)
    if term.hidden or not term.window or vim.api.nvim_win_get_config(term.window).relative == '' then return end
    local all = require('toggleterm.terminal').get_all()
    for i, t in ipairs(all) do
      if t.id == term.id then
        vim.api.nvim_win_set_config(term.window, {
          footer = { { string.format(' %d/%d ', i, #all), 'Comment' } },
          footer_pos = 'right',
        })
      end
    end
  end,
}

local terms = require 'toggleterm.terminal'
local Terminal = terms.Terminal

-- Focus terminal `id`, closing any other open toggleterm first so floats swap
-- rather than stack (NToggleTerm on its own only opens N, it does not close the
-- rest). Reachable from normal, insert and terminal mode, since a count prefix
-- like 2<C-\> can only be typed in normal mode.
local function focus_term(id)
  if vim.startswith(vim.fn.mode(), 'i') then vim.cmd 'stopinsert' end
  for _, term in ipairs(terms.get_all(true)) do
    if term.id ~= id and term:is_open() then term:close() end
  end
  local term = terms.get(id)
  if term and term:is_open() then
    term:focus()
    vim.cmd 'startinsert'
  else
    vim.cmd(id .. 'ToggleTerm')
  end
end

-- Step to the neighbouring terminal by id, relative to the focused one (or the
-- last one used if none is open). Stepping right past the last terminal opens a
-- new one; stepping left past the first does nothing. Hidden terminals like
-- lazygit are skipped.
local function step_term(dir)
  local all = terms.get_all()
  if #all == 0 then return focus_term(1) end

  local current = terms.get_focused_id()
  if not current then
    local last = terms.get_last_focused()
    current = last and not last.hidden and last.id or all[1].id
  end

  local idx
  for i, term in ipairs(all) do
    if term.id == current then idx = i end
  end
  if not idx then return focus_term(all[1].id) end

  local target = all[idx + dir]
  if target then
    focus_term(target.id)
  elseif dir > 0 then
    focus_term(all[#all].id + 1)
  end
end

vim.keymap.set({ 'n', 'i', 't' }, '<A-h>', function() step_term(-1) end, { desc = 'Previous terminal' })
vim.keymap.set({ 'n', 'i', 't' }, '<A-l>', function() step_term(1) end, { desc = 'Next terminal' })

local function term_label(term)
  local name = term.display_name
  if not name then
    local cmd = term.name and vim.split(term.name, ';')[1] or term.cmd or vim.o.shell
    if type(cmd) == 'table' then cmd = table.concat(cmd, ' ') end
    name = vim.fn.fnamemodify(vim.split(cmd, ' ')[1], ':t')
  end
  return string.format('%d: %-18s %s', term.id, name, term.dir and vim.fn.fnamemodify(term.dir, ':~') or '')
end

-- Telescope picker over the toggleterms, previewing each one's scrollback.
-- :Telescope buffers can't do this: toggleterm sets buflisted = false on its
-- buffers and builtin.buffers only lists listed ones.
local function term_picker()
  local all = terms.get_all()
  if #all == 0 then return vim.notify('No toggleterms open yet', vim.log.levels.INFO) end

  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local previewers = require 'telescope.previewers'
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local conf = require('telescope.config').values

  pickers
    .new({}, {
      prompt_title = 'Terminals',
      finder = finders.new_table {
        results = all,
        entry_maker = function(term)
          local label = term_label(term)
          return { value = term, ordinal = label, display = label, bufnr = term.bufnr }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = previewers.new_buffer_previewer {
        title = 'Terminal',
        define_preview = function(self, entry)
          local lines = { '(not started)' }
          if entry.bufnr and vim.api.nvim_buf_is_valid(entry.bufnr) then
            lines = vim.api.nvim_buf_get_lines(entry.bufnr, 0, -1, false)
            -- terminal buffers are padded out to the window height with blanks
            while #lines > 1 and lines[#lines]:match '^%s*$' do
              table.remove(lines)
            end
          end
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          -- park the preview on the newest output rather than the top
          vim.schedule(function()
            if vim.api.nvim_win_is_valid(self.state.winid) then
              vim.api.nvim_win_set_cursor(self.state.winid, { #lines, 0 })
              vim.api.nvim_win_call(self.state.winid, function() vim.cmd 'normal! zb' end)
            end
          end)
        end,
      },
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then focus_term(entry.value.id) end
        end)
        return true
      end,
    })
    :find()
end

vim.keymap.set('n', '<leader>tt', term_picker, { desc = '[T]oggle: pick [t]erminal' })
vim.keymap.set({ 'i', 't' }, '<A-t>', term_picker, { desc = 'Pick terminal' })

-- Lazygit in a floating terminal. Pinned to a high id: ids are handed out by
-- next_id() starting at 1, so an unpinned hidden terminal would claim id 1 and
-- 1ToggleTerm would then toggle lazygit instead of a shell.
local lazygit = Terminal:new {
  id = 99,
  cmd = 'lazygit',
  hidden = true,
  direction = 'float',
  float_opts = { border = 'curved' },
}

vim.keymap.set('n', '<leader>gg', function()
  -- toggleterm would termopen a missing binary, then close_on_exit tears the
  -- float straight back down, so the keymap looks like it does nothing
  if vim.fn.executable 'lazygit' == 0 then return vim.notify('lazygit not found on PATH', vim.log.levels.WARN) end
  lazygit:toggle()
end, { desc = '[G]it: Lazy[g]it' })
