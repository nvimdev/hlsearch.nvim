local api, fn = vim.api, vim.fn
local group = api.nvim_create_augroup('Hlsearch', { clear = true })

local function stop_hl()
  if vim.v.hlsearch == 0 then
    return
  end
  local keycode = api.nvim_replace_termcodes('<Cmd>nohl<CR>', true, false, true)
  api.nvim_feedkeys(keycode, 'n', false)
end

local function start_hl()
  local res = fn.getreg('/')
  if vim.v.hlsearch == 1 and (
      res:find([[%#]]) or
      fn.search([[\%#\zs]] .. res, 'cnW') == 0
    ) then
    stop_hl()
  end
end

local buffers = {}

local function hs_event(bufnr)
  if buffers[bufnr] then
    return
  end
  buffers[bufnr] = true
  local cm_id = api.nvim_create_autocmd('CursorMoved', {
    buffer = bufnr,
    group = group,
    callback = function()
      start_hl()
    end,
    desc = 'Auto hlsearch',
  })

  local ie_id = api.nvim_create_autocmd('InsertEnter', {
    buffer = bufnr,
    group = group,
    callback = function()
      stop_hl()
    end,
    desc = 'Auto remove hlsearch',
  })

  api.nvim_create_autocmd('BufDelete', {
    buffer = bufnr,
    group = group,
    callback = function(opt)
      buffers[bufnr] = nil
      pcall(api.nvim_del_autocmd, cm_id)
      pcall(api.nvim_del_autocmd, ie_id)
      pcall(api.nvim_del_autocmd, opt.id)
    end,
  })
end

local function setup()
  api.nvim_create_autocmd('BufWinEnter', {
    group = group,
    callback = function(opt)
      hs_event(opt.buf)
    end,
    desc = 'hlsearch.nvim event',
  })
end

return {
  setup = setup,
}
