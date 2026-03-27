-- Essential Java ftplugin: indentation + Makefile/quickfix workflow

if vim.b.java_ft_done then return end
vim.b.java_ft_done = true

-- Editor defaults (Java)
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.expandtab = true
vim.opt_local.textwidth = 200
vim.opt_local.colorcolumn = '201'

-- Find nearest Makefile upward from current file
local function make_root()
  local dir = vim.fn.expand '%:p:h'
  local mf = vim.fs.find({ 'Makefile', 'makefile', 'GNUmakefile' }, { upward = true, path = dir })[1]
  return mf and vim.fs.dirname(mf) or vim.fn.getcwd()
end

-- Use :make (quickfix) but run it at the Makefile root
vim.opt_local.makeprg = 'make -k -C ' .. vim.fn.shellescape(make_root())

-- :Make [target...] wrapper that opens quickfix when errors exist
vim.api.nvim_create_user_command('Make', function(opts)
  local args = opts.args or ''
  if args == '' then
    vim.cmd 'make'
  else
    vim.cmd('make ' .. args)
  end
  if #vim.fn.getqflist() > 0 then vim.cmd 'copen' end
end, { nargs = '*', desc = 'Run make (at Makefile root) and open quickfix on errors' })

-- Handy keymaps (Java-only)
vim.keymap.set('n', '<localleader>mm', '<cmd>Make<cr>', { buffer = true, desc = 'make' })
vim.keymap.set('n', '<localleader>mq', '<cmd>copen<cr>', { buffer = true, desc = 'quickfix open' })
vim.keymap.set('n', '<localleader>mc', '<cmd>cclose<cr>', { buffer = true, desc = 'quickfix close' })
vim.keymap.set('n', '<localleader>mn', '<cmd>cnext<cr>', { buffer = true, desc = 'quickfix next' })
vim.keymap.set('n', '<localleader>mp', '<cmd>cprev<cr>', { buffer = true, desc = 'quickfix prev' })
