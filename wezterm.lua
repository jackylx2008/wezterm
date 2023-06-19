-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux
local font_size = 12
local launch_menu = {}
local config = {}
local home_dir = ""

wezterm.on("gui-startup", function()
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	home_dir = os.getenv("HOMEDRIVE") .. os.getenv("HOMEPATH") .. "\\.config\\wezterm\\pic\\"
	font_size = 10
	default_prog = { "C:/Program Files/PowerShell/7/pwsh.exe" }

	-- Find installed visual studio version(s) and add their compilation
	-- environment command prompts to the menu
	for _, vsvers in ipairs(wezterm.glob("Microsoft Visual Studio/20*", "C:/Program Files (x86)")) do
		local year = vsvers:gsub("Microsoft Visual Studio/", "")
		table.insert(launch_menu, {
			label = "x64 Native Tools VS " .. year,
			args = {
				"cmd.exe",
				"/k",
				"C:/Program Files (x86)/" .. vsvers .. "/BuildTools/VC/Auxiliary/Build/vcvars64.bat",
			},
		})
	end
end

if wezterm.target_triple == "x86_64-apple-darwin" then
	home_dir = os.getenv("HOME") .. "/.config/wezterm/pic/"
end

-- The set of schemes that we like and want to put in our rotation
-- local schemes = {}
-- for name, scheme in pairs(wezterm.get_builtin_color_schemes()) do
-- 	table.insert(schemes, name)
-- end
--
-- wezterm.on("window-config-reloaded", function(window, pane)
-- 	-- If there are no overrides, this is our first time seeing
-- 	-- this window, so we can pick a random scheme.
-- 	if not window:get_config_overrides() then
-- 		-- Pick a random scheme name
-- 		local scheme = schemes[math.random(#schemes)]
-- 		window:set_config_overrides({
-- 			color_scheme = scheme,
-- 		})
-- 		print(scheme)
-- 	end
-- end)

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Random pic
local file = io.open(home_dir .. "pic_list.txt", "r")
local pic_list = {}
for line in file:lines() do
	table.insert(pic_list, line)
end
file:close()
local pic = home_dir .. pic_list[math.random(#pic_list)]
config.window_background_image = pic
config.window_background_image_hsb = {
	-- Darken the background image by reducing it to 1/3rd
	brightness = 0.6,

	-- You can adjust the hue by scaling its value.
	-- a multiplier of 1.0 leaves the value unchanged.
	-- hue = 0.5,

	-- You can adjust the saturation also.
	saturation = 1.0,
}
-- This is where you actually apply your config choices
local font = "JetBrainsMonoNL Nerd Font Mono"
-- local font = "Hack Nerd Font Mono"
-- local font = "FiraMono Nerd Font Mono"

config.default_prog = default_prog
config.native_macos_fullscreen_mode = true
-- config.window_background_opacity = 0.80
config.font = wezterm.font(font, { weight = "Bold", italic = false })
config.color_scheme = "Google Dark (base16)"
config.font_size = font_size
config.native_macos_fullscreen_mode = true
config.window_padding = {
	left = 5,
	right = 5,
	top = 5,
	bottom = 5,
}
config.use_ime = true
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = true
config.show_tab_index_in_tab_bar = true
config.inactive_pane_hsb = {
	hue = 5.0,
	saturation = 1.0,
	brightness = 1.0,
}
config.initial_cols = 90
config.initial_rows = 40
config.warn_about_missing_glyphs = false
config.exit_behavior = "Close"
config.launch_menu = launch_menu
config.leader = { key = ";", mods = "CTRL", timeout_milliseconds = 1500 }
config.keys = {
	-- New/Close pane
	-- New tab based on current pane
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	-- Close current pane
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	-- Close current tab
	{ key = "x", mods = "SHIFT|CTRL", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },

	-- Navigate cursor between panes
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	-- AdjustPaneSize
	{ key = "H", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Left", 6 } }) },
	{ key = "J", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Down", 3 } }) },
	{ key = "K", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Up", 3 } }) },
	{ key = "L", mods = "LEADER", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },

	-- Toggle zoom current pane
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	-- Choose tab by leader num
	{ key = "a", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "s", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	-- { key = "d", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	-- { key = "f", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },

	-- Split the pane
	{ key = "d", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "f", mods = "LEADER", action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }) },
	-- Toggle full screen
	{ key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
	-- Copy and paste to the clipboard
	-- { key = "v", mods = "SHIFT|CTRL", action = "Paste" },
	-- { key = "c", mods = "SHIFT|CTRL", action = "Copy" },
	-- Navigate the tab
	{ key = "i", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = 1 }) },
	{ key = "o", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = -1 }) },
	{ key = "n", mods = "LEADER", action = "ShowTabNavigator" },
}
-- and finally, return the configuration to wezterm
return config
