return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  cond = function()
    return vim.fn.has 'nvim-0.12' == 0
  end,
  ft = { 'markdown' },
  opts = {
    sign = { enabled = false },
    -- heading = { width = 'block' },
    completions = { lsp = { enabled = true } },
  },
}
