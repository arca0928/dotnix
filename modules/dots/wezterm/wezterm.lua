local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.colors = require("0x96f")
config.check_for_updates = false

config.font = wezterm.font("Moralerspace Neon")

config.use_ime = true
config.window_background_opacity = 0.65
config.kde_window_background_blur = true

config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.show_close_tab_button_in_tabs = false

config.use_fancy_tab_bar = false

return config
