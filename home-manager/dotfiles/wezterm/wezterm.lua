-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- config.color_scheme = 'Kanagawa (Gogh)'
config.font = wezterm.font 'BlexMono Nerd Font'
config.enable_tab_bar = false

return config
