local M = {}

local function current_buffer_is_dashboard()
  return vim.bo.filetype == 'alpha'
end

local function current_buffer_is_special()
  return vim.bo.buftype ~= ''
end

local function listed_buffers()
  return vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())
end

local function show_dashboard()
  if vim.fn.exists ':Alpha' == 2 then
    vim.cmd 'Alpha'
  else
    vim.cmd 'enew'
  end
end

function M.close_current_file(opts)
  opts = opts or {}

  if current_buffer_is_dashboard() then
    vim.cmd 'quitall'
    return
  end

  if current_buffer_is_special() then
    vim.cmd 'quit'
    return
  end

  local buf = vim.api.nvim_get_current_buf()

  if opts.write then
    vim.cmd 'write'
  elseif vim.bo[buf].modified then
    vim.notify('No write since last change. Use :wq to save, or :q! to quit Neovim.', vim.log.levels.WARN)
    return
  end

  if #listed_buffers() <= 1 then
    vim.cmd 'enew'
    vim.api.nvim_buf_delete(buf, { force = false })
    show_dashboard()
    return
  end

  vim.cmd 'bprevious'
  vim.api.nvim_buf_delete(buf, { force = false })
end

vim.api.nvim_create_user_command('SmartQuit', function()
  M.close_current_file { write = false }
end, {})

vim.api.nvim_create_user_command('SmartWriteQuit', function()
  M.close_current_file { write = true }
end, {})

vim.cmd [[
cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() ==# 'q' ? 'SmartQuit' : 'q'
cnoreabbrev <expr> wq getcmdtype() == ':' && getcmdline() ==# 'wq' ? 'SmartWriteQuit' : 'wq'
]]

return M
