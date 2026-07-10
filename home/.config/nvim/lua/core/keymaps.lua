-- Keymaps for better default experience

-- Set leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- For conciseness
local opts = { noremap = true, silent = true }

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Directional movement: h=up, j=down, k=left, l=right
vim.keymap.set({ 'n', 'x', 'o' }, 'h', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x', 'o' }, 'k', 'h', opts)
vim.keymap.set({ 'n', 'x', 'o' }, 'l', 'l', opts)

-- clear highlights and save modified buffers
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR><cmd>silent! update<CR>', opts)
vim.keymap.set('i', '<Esc>', '<Esc><cmd>silent! update<CR>', opts)

-- save file
vim.keymap.set('n', '<C-s>', '<cmd> w <CR>', opts)

-- save file without auto-formatting
vim.keymap.set('n', '<leader>sn', '<cmd>noautocmd w <CR>', opts)

-- quit file
vim.keymap.set('n', '<C-q>', '<cmd>SmartQuit<CR>', opts)

-- delete single character without copying into register
vim.keymap.set('n', 'x', '"_x', opts)

-- Vertical scroll and center
vim.keymap.set('n', '<C-h>', '<C-u>zz', opts)
vim.keymap.set('n', '<C-j>', '<C-d>zz', opts)

-- Find and center
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Resize with arrows
vim.keymap.set('n', '<Up>', ':resize -2<CR>', opts)
vim.keymap.set('n', '<Down>', ':resize +2<CR>', opts)
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', opts)
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', opts)

-- Split with Shift-arrows
vim.keymap.set('n', '<S-Up>', ':leftabove split<CR>', opts)
vim.keymap.set('n', '<S-Down>', ':rightbelow split<CR>', opts)
vim.keymap.set('n', '<S-Left>', ':leftabove vsplit<CR>', opts)
vim.keymap.set('n', '<S-Right>', ':rightbelow vsplit<CR>', opts)

-- Navigate between splits with Alt-arrows
vim.keymap.set('n', '<M-Up>', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<M-Down>', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<M-Left>', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<M-Right>', ':wincmd l<CR>', opts)

-- Windows-style word selection
vim.keymap.set('n', '<C-S-Left>', 'vb', opts)
vim.keymap.set('n', '<C-S-Right>', 've', opts)
vim.keymap.set('x', '<C-S-Left>', 'b', opts)
vim.keymap.set('x', '<C-S-Right>', 'e', opts)
vim.keymap.set('i', '<C-S-Left>', '<Esc>vb', opts)
vim.keymap.set('i', '<C-S-Right>', '<Esc>ve', opts)

-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<C-i>', '<C-i>', opts) -- to restore jump forward
vim.keymap.set('n', '<leader>x', '<cmd>SmartQuit<CR>', opts) -- close file
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Increment/decrement numbers
vim.keymap.set('n', '<leader>+', '<C-a>', opts) -- increment
vim.keymap.set('n', '<leader>-', '<C-x>', opts) -- decrement

-- Window management
vim.keymap.set('n', '<leader>v', '<C-w>v', opts) -- split window vertically
vim.keymap.set('n', '<leader>h', '<C-w>s', opts) -- split window horizontally
vim.keymap.set('n', '<leader>se', '<C-w>=', opts) -- make split windows equal width & height
vim.keymap.set('n', '<leader>xs', ':close<CR>', opts) -- close current split window

-- Tabs
vim.keymap.set('n', '<leader>to', ':tabnew<CR>', opts) -- open new tab
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opts) -- close current tab
vim.keymap.set('n', '<leader>tn', ':tabn<CR>', opts) --  go to next tab
vim.keymap.set('n', '<leader>tp', ':tabp<CR>', opts) --  go to previous tab

-- Toggle line wrapping
vim.keymap.set('n', '<leader>lw', '<cmd>set wrap!<CR>', opts)

-- Press jk fast to exit insert mode
vim.keymap.set('i', 'jk', '<ESC>', opts)
vim.keymap.set('i', 'kj', '<ESC>', opts)

-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)

-- Move text up and down
vim.keymap.set('v', '<A-j>', ':m .+1<CR>==', opts)
vim.keymap.set('v', '<A-k>', ':m .-2<CR>==', opts)

-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', opts)

-- Windows-style paste from the system clipboard
vim.keymap.set('n', '<C-v>', '"+p', opts)
vim.keymap.set('i', '<C-v>', '<C-r>+', opts)
vim.keymap.set('c', '<C-v>', '<C-r>+', opts)
vim.keymap.set('v', '<C-v>', '"+p', opts)
vim.keymap.set('n', '<RightMouse>', '"+p', opts)
vim.keymap.set('i', '<RightMouse>', '<C-r>+', opts)
vim.keymap.set('v', '<RightMouse>', '"+p', opts)

-- Replace word under cursor
vim.keymap.set('n', '<leader>j', '*``cgn', opts)

-- Explicitly yank to system clipboard (highlighted and entire row)
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])

-- Toggle diagnostics
local diagnostics_active = true

vim.keymap.set('n', '<leader>do', function()
  diagnostics_active = not diagnostics_active

  if diagnostics_active then
    vim.diagnostic.enable(true)
  else
    vim.diagnostic.enable(false)
  end
end)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Go to previous diagnostic message' })

vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Go to next diagnostic message' })

vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
