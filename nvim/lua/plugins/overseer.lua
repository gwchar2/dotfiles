return {
  'stevearc/overseer.nvim',
  cmd = {
    'OverseerOpen',
    'OverseerClose',
    'OverseerToggle',
    'OverseerRun',
    'OverseerRunCmd',
    'OverseerQuickAction',
    'OverseerTaskAction',
    'OverseerClearCache',
  },
  keys = {
    { '<leader>or', '<cmd>OverseerRun<CR>', desc = '[O]verseer [R]un task' },
    { '<leader>ot', '<cmd>OverseerToggle<CR>', desc = '[O]verseer [T]oggle tasks' },
    { '<leader>oa', '<cmd>OverseerTaskAction<CR>', desc = '[O]verseer task [A]ction' },
  },
  opts = {
    strategy = {
      'toggleterm',
      use_shell = false,
    },
    templates = { 'builtin' },
    task_list = {
      direction = 'right',
      min_width = 42,
      max_width = 80,
      bindings = {
        ['q'] = 'Close',
        ['<CR>'] = 'RunAction',
        ['o'] = 'Open',
      },
    },
  },
  dependencies = {
    {
      'akinsho/toggleterm.nvim',
      version = '*',
      opts = {
        direction = 'float',
        float_opts = { border = 'curved' },
      },
    },
  },
}
