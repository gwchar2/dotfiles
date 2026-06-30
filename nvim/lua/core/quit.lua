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

local function visible_windows()
  return vim.tbl_filter(function(win)
    return vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_config(win).relative == ''
  end, vim.api.nvim_tabpage_list_wins(0))
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
    if #visible_windows() > 1 then
      vim.cmd 'close'
    else
      vim.cmd 'quitall'
    end
    return
  end

  if current_buffer_is_special() then
    vim.cmd(opts.force and 'close!' or 'close')
    return
  end

  local buf = vim.api.nvim_get_current_buf()

  if opts.write then
    vim.cmd 'write'
  elseif vim.bo[buf].modified and not opts.force then
    vim.notify('No write since last change. Use :wq to save, or :q! to quit Neovim.', vim.log.levels.WARN)
    return
  end

  if #visible_windows() > 1 then
    vim.cmd(opts.force and 'close!' or 'close')
    return
  end

  if #listed_buffers() <= 1 then
    vim.cmd 'enew'
    vim.api.nvim_buf_delete(buf, { force = opts.force or false })
    show_dashboard()
    return
  end

  vim.cmd 'bprevious'
  vim.api.nvim_buf_delete(buf, { force = opts.force or false })
end

vim.api.nvim_create_user_command('SmartQuit', function()
  M.close_current_file { write = false }
end, {})

vim.api.nvim_create_user_command('SmartWriteQuit', function()
  M.close_current_file { write = true }
end, {})

vim.api.nvim_create_user_command('Fq', function()
  M.close_current_file { force = true, write = false }
end, {})

vim.api.nvim_create_user_command('Fwq', function()
  M.close_current_file { write = true }
end, {})

vim.cmd [[
cnoreabbrev <expr> fq getcmdtype() == ':' && getcmdline() ==# 'fq' ? 'Fq' : 'fq'
cnoreabbrev <expr> fwq getcmdtype() == ':' && getcmdline() ==# 'fwq' ? 'Fwq' : 'fwq'
]]

return M
