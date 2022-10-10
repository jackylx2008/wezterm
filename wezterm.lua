local wezterm = require 'wezterm'
local act = wezterm.action
local launch_menu = {}
local set_environment_variables = {}

-- Show which key table is active in the status area
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name
  end
  window:set_right_status(name or '')
end)

local function basename(s)
    return string.gsub(s, '(.*[/\\])(.*)', '%2')
end
 
-- Title
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
    local pane = tab.active_pane
    local title = basename(pane.foreground_process_name)

    return {{
        Text = ' ' .. title .. ' '
    }}
end)

-- Initial startup
wezterm.on('gui-startup', function(cmd)
    local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
    window:gui_window():maximize()  --Max window
end)

return {
    -- Window
    native_macos_fullscreen_mode = true,
    adjust_window_size_when_changing_font_size = true,
    window_close_confirmation = 'NeverPrompt',
    -- window_decorations = 'RESIZE',
    window_decorations = 'TITLE|RESIZE',
    window_background_opacity = 0.85,
    window_padding = {
        left = 5,
        right = 5,
        top = 5,
        bottom = 5
    },
    window_background_image_hsb = {
        brightness = 0.8,
        hue = 1.0,
        saturation = 1.0
    },

  -- Font
  font = wezterm.font_with_fallback {
    -- 'Fira Code',
    -- 'Hack Nerd Font Mono'
  },
  font_size = 14,
  use_ime = true,

-- Tab bar appearance
  hide_tab_bar_if_only_one_tab = true,
  enable_tab_bar = true,
  show_tab_index_in_tab_bar = true,
  -- tab_bar_at_bottom = true,
  -- use_fancy_tab_bar = false,  hide_tab_bar_if_only_one_tab = true,
  inactive_pane_hsb = {
        hue = 5.0,
        saturation = 1.0,
        brightness = 1.0
  },

  initial_cols = 90,
  initial_rows = 40,
  color_scheme = 'Gruvbox Dark',
  warn_about_missing_glyphs = false,
  exit_behavior = "Close",

  -- Keys
  -- Allow using ^ with single key press.
  use_dead_keys = true,
  launch_menu = {},
    leader = { key=";", mods="CTRL", timeout_milliseconds = 1500 },
    disable_default_key_bindings = true,
    keys = {
        -- New/Close pane
        -- New tab based on current pane
        { key = "c", mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
        -- Close current pane
        { key = "x", mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
        -- Close current tab
        { key = "X", mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},

        -- Navigate cursor between panes
        { key = "h", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
        { key = "j", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
        { key = "k", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
        { key = "l", mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
        -- AdjustPaneSize
        { key = "H", mods = "LEADER", action=wezterm.action{AdjustPaneSize={"Left", 6}}},
        { key = "J", mods = "LEADER", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
        { key = "K", mods = "LEADER", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
        { key = "L", mods = "LEADER", action=wezterm.action{AdjustPaneSize={"Right", 5}}},

        -- Toggle zoom current pane
        { key = "z", mods = "LEADER",       action="TogglePaneZoomState" },
        -- Choose tab by leader num
        { key = "1", mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
        { key = "2", mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
        { key = "3", mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
        { key = "4", mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
        { key = "5", mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
        { key = "6", mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
        { key = "7", mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
        { key = "8", mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
        { key = "9", mods = "LEADER",       action=wezterm.action{ActivateTab=8}},

        -- Split the pane
        { key = "-", mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
        { key = "|", mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
        -- Toggle full screen
        { key = "n", mods="SHIFT|CTRL",     action="ToggleFullScreen" },
        -- Copy and paste to the clipboard
        { key = "v",   mods="SHIFT|CTRL",     action="Paste"},
        { key = "c",   mods="SHIFT|CTRL",     action="Copy"},
        -- Navigate the tab
        { key = "i",   mods="LEADER",     action = wezterm.action {ActivateTabRelative = 1}},
        { key = "o",   mods="LEADER",     action = wezterm.action {ActivateTabRelative = -1}},
        { key = "n",   mods="LEADER",     action = 'ShowTabNavigator'},
        -- Multiple panes
        -- {
        --     key = '[',
        --     mods = 'CTRL',
        --     action = wezterm.action.Multiple {wezterm.action.SplitPane {
        --         direction = 'Right',
        --         size = {
        --             Percent = 40
        --         }
        --     }, wezterm.action.SplitPane {
        --         direction = 'Down',
        --         size = {
        --             Percent = 40
        --         }
        --     }}
        -- }, -- H12
        -- {
        --     key = ']',
        --     mods = 'CTRL',
        --     action = wezterm.action.Multiple {wezterm.action.SplitPane {
        --         direction = 'Down',
        --         size = {
        --             Percent = 40
        --         }
        --     }, wezterm.action.SplitPane {
        --         direction = 'Left',
        --         size = {
        --             Percent = 60
        --         }
        --     }}
        -- }, -- Square
        -- {
        --     key = '0',
        --     mods = 'CTRL',
        --     action = wezterm.action.Multiple {wezterm.action.SplitPane {
        --         direction = 'Right',
        --         size = {
        --             Percent = 40
        --         }
        --     }, wezterm.action.SplitPane {
        --         direction = 'Down',
        --         size = {
        --             Percent = 50
        --         }
        --     }, wezterm.action.SplitPane {
        --         direction = 'Down',
        --         size = {
        --             Percent = 40
        --         },
        --         top_level = true
        --     }}
        -- },
    },
    set_environment_variables = {},
    set_environment_variables = set_environment_variables,
    launch_menu = launch_menu
}
