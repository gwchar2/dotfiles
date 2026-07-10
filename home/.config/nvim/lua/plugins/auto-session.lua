return {
  'rmagatti/auto-session',
  lazy = false,
  opts = {
    auto_restore = true,
    auto_save = true,
    suppressed_dirs = { '~/', '~/Downloads', '/' },
    session_lens = {
      load_on_setup = false,
      theme_conf = { border = true },
    },
  },
  keys = {
    { '<leader>ss', '<cmd>SessionSave<CR>', desc = '[S]ession [S]ave' },
    { '<leader>sl', '<cmd>SessionRestore<CR>', desc = '[S]ession [L]oad' },
    { '<leader>sd', '<cmd>SessionDelete<CR>', desc = '[S]ession [D]elete' },
    { '<leader>sf', '<cmd>Autosession search<CR>', desc = '[S]ession [F]ind' },
  },
}
