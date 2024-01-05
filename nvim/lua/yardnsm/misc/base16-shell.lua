-- This mini util sets up base16-shell with the appropriate colors for the currently set base16
-- colorscheme

local base16_utils = require("yardnsm.misc.base16-utils")

-- Fetching the env from tmux is a bit slow :(
local should_use_tmux_env = false

local M = {}

local get_tmux_env = function(name)
  local res = vim.system({ 'tmux', 'show-environment', name }):wait()

  if res.code ~= 0 then
    return nil
  end

  return vim.trim(vim.split(res.stdout, "=")[2])
end

M.get_shell_theme = function()
  local theme = vim.env.BASE16_THEME

  if should_use_tmux_env and theme == nil and vim.env.TMUX ~= nil then
    return get_tmux_env('BASE16_THEME')
  end

  return theme
end

M.refresh = function()
  if vim.g.colors_name == M.get_shell_theme() then
    return
  end

  base16_utils.run_handler(function(c)
    local on_exit = function(res)
      io.write(res.stdout)
    end

    vim.system({
      'base16-shell',
      vim.g.colors_name,
      string.sub(c.base00, 2),
      string.sub(c.base01, 2),
      string.sub(c.base02, 2),
      string.sub(c.base03, 2),
      string.sub(c.base04, 2),
      string.sub(c.base05, 2),
      string.sub(c.base06, 2),
      string.sub(c.base07, 2),
      string.sub(c.base08, 2),
      string.sub(c.base09, 2),
      string.sub(c.base0A, 2),
      string.sub(c.base0B, 2),
      string.sub(c.base0C, 2),
      string.sub(c.base0D, 2),
      string.sub(c.base0F, 2),
    }, nil, on_exit)
  end)
end

M.setup = function()
  base16_utils.attach_handler({ "base16-*", "base46-*" }, M.refresh)
end

return M
