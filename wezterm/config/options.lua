local config = {}

config.automatically_reload_config = false
config.disable_default_key_bindings = true
config.disable_default_mouse_bindings = true
config.window_close_confirmation = 'NeverPrompt'
config.use_ime = true
config.front_end = 'WebGpu'
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true
config.use_dead_keys = false
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'
config.adjust_window_size_when_changing_font_size = false
config.enable_kitty_graphics = true

return config