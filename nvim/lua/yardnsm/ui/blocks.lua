local status_ok, nvim_devicons = pcall(require, "nvim-web-devicons")
if not status_ok then
  nvim_devicons = nil
end

local lsp_statusline_utils = require("yardnsm.lsp.statusline")

local M = {}

local statusline_visual_percentages = {
  "__",
  "▁▁",
  "▂▂",
  "▃▃",
  "▄▄",
  "▅▅",
  "▆▆",
  "▇▇",
  "██",
}

local diagnostic_highlights = {
  info = "St_IndicatorNeutral",
  warning = "St_IndicatorWarning",
  error = "St_IndicatorError",
  success = "St_IndicatorSuccess",
}

local get_devicon_for_buffer = function(bufnr)
  if nvim_devicons == nil then
    return "", "", ""
  end

  local expand_file = bufnr ~= nil and ("#" .. bufnr) or "%"

  local filename = vim.fn.expand(expand_file .. ":t")
  local extension = vim.fn.expand(expand_file .. ":e")

  local icon, color = nvim_devicons.get_icon_color(filename, extension, { default = true })

  local _, hl_group = nvim_devicons.get_icon(filename, extension, { default = true })

  return icon, hl_group, color
end

-- Sometimes, buffers are being created with the full path (such as when opening file with
-- NvimTree). I want the path to always be shown relatively to the CWD.
M.relpath = function(bufnr)
  local expand_file = bufnr ~= nil and ("#" .. bufnr) or "%"
  local relpath = vim.fn.expand(expand_file .. ":~:.")

  if relpath == "" then
    return "[No Name]"
  end

  return relpath
end

M.fullpath = function(bufnr, shorten)
  local expand_file = bufnr ~= nil and ("#" .. bufnr) or "%"

  local cwdpath = vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
  local relpath = vim.fn.expand(expand_file .. ":.")

  if relpath == "" then
    return "[No Name]"
  end

  if shorten == true then
    cwdpath = vim.fn.pathshorten(cwdpath)
  end

  return vim.fs.joinpath(cwdpath, relpath)
end

M.navic = function()
  local navic_ok, navic = pcall(require, "nvim-navic")
  if not navic_ok then
    return ""
  end

  if not navic.is_available() then
    return ""
  end

  return "%<%-{%v:lua.require'nvim-navic'.get_location()%}"
end

---@param state LineState
M.file_tab_like = function(state)
  local focused = state.focused and state.active

  local base_hl = focused and "Wb_TabActive" or "Wb_TabInactive"
  local icon, hl_group = get_devicon_for_buffer(state.bufnr)

  local expand_file = state.bufnr ~= nil and ("#" .. state.bufnr) or "%"
  local filename = vim.fn.expand(expand_file .. ":t")

  if filename == "" then
    filename = "[No Name]"
  end

  -- Special case for Quickfix
  if state.ft == "qf" then
    filename = "%q"
    icon = ""
  end

  return table.concat({
    "%#" .. base_hl .. "#",
    focused and "%#" .. hl_group .. "#" or "",
    "  " .. icon .. "  ",

    "%#" .. base_hl .. "#",
    filename,
    " %m ",
  })
end

M.indent_info = function()
  local sw = vim.o.shiftwidth
  local et = vim.o.expandtab and "··  " or "»   "

  return ("%s %s "):format(sw, et)
end

M.visual_percentage = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")

  local index = vim.fn.float2nr(vim.fn.ceil((current_line * 1.0) / total_lines * #statusline_visual_percentages))

  return statusline_visual_percentages[index]
end

M.paste = function()
  if vim.o.paste then
    return "PST "
  end

  return ""
end

M.spell = function()
  if vim.wo.spell then
    return "SPL "
  end

  return ""
end

M.search_count = function()
  local search = vim.fn.searchcount({ maxcount = 0 })
  local current = search.current
  local total = search.total

  if not vim.go.hlsearch or total == 0 then
    return ""
  end

  return "[" .. current .. "/" .. total .. "]"
end

---@param state LineState
M.filetype = function(state)
  local filetype = state.ft

  if filetype == "" then
    return "no ft"
  end

  return filetype
end

M.diagnostics = function()
  local hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
  local infos = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })

  local highlight = diagnostic_highlights.success

  local result = ""

  if hints ~= 0 then
    highlight = diagnostic_highlights.info
    result = result .. vim.fn.printf("%%#%s# ‹!:%d›", highlight, hints)
  end

  if infos ~= 0 then
    highlight = diagnostic_highlights.info
    result = result .. vim.fn.printf("%%#%s# ‹I:%d›", highlight, infos)
  end

  if warnings ~= 0 then
    highlight = diagnostic_highlights.warning
    result = result .. vim.fn.printf("%%#%s# ‹W:%d›", highlight, warnings)
  end

  if errors ~= 0 then
    highlight = diagnostic_highlights.error
    result = result .. vim.fn.printf("%%#%s# ‹E:%d›", highlight, errors)
  end

  return result .. vim.fn.printf("%%#%s#   ", highlight)
end

M.lsp = function()
  local client_attahced = lsp_statusline_utils.is_client_attahced()
  local server_names = lsp_statusline_utils.get_servers_names()

  if not client_attahced then
    return ""
  end

  return "󰄭  " .. server_names .. " ⋅"
end

M.vcs_branch = function()
  local branch = vim.fn.exists("g:gitsigns_head") ~= 0 and vim.g.gitsigns_head or ""

  if branch == "" then
    return ""
  end

  if string.len(branch) > 20 then
    branch = string.sub(branch, 1, 20) .. "… "
  end

  return "  " .. branch .. " ⋅"
end

M.vcs_stats = function()
  if not vim.fn.exists("*sy#start") then
    return ""
  end

  local stats = vim.b.gitsigns_status_dict

  if stats == nil then
    return ""
  end

  stats = { stats.added, stats.changed, stats.removed }

  local hl_groups = { "St_VCSAdd", "St_VCSChange", "St_VCSDelete" }
  local symbols = { "+", "~", "-" }

  local result = ""

  for index, value in ipairs(stats) do
    if value > 0 then
      result = result .. "%" .. vim.fn.printf("#%s#%s%s ", hl_groups[index], symbols[index], value)
    end
  end

  if result then
    return string.sub(result, 1, -2)
  end
end

M.file_tree_offset = function()
  local file_tree_filetypes = {
    "neo-tree",
    "DiffviewFiles",
  }

  for _, win in pairs(vim.api.nvim_tabpage_list_wins(0)) do
    local ft = vim.bo[vim.api.nvim_win_get_buf(win)].ft
    if vim.tbl_contains(file_tree_filetypes, ft) then
      local width = vim.api.nvim_win_get_width(win) + 1
      return string.rep(" ", width)
    end
  end

  return ""
end

return M
