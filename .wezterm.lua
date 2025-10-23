-- Ryan's wezterm config
-- Please check the documentation for more information:
-- https://wezterm.org/config/files.html#configuration-file-structure

-- This config is all stored in a single file to keep it portable.
-- As such it is a little long, so here is a table of contents:
-- 1. Helper functions: You can most likely ignore this section. It is just some simple functions
--                      that I use to make the config a little cleaner.
-- 2. Windows Configuration: Configuration that is specific to Windows.
-- 3. Linux Configuration: Configuration that is specific to Linux.
-- 4. Universal Configuration: Configuration that is universal and should work on all systems.

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-----------------------
-- Helper functions
-----------------------
function TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end
-----------------------
-- End Helper functions
-----------------------

---------------------------------------------------------------
-- Windows Configuration
---------------------------------------------------------------
function windows_config(leader, leaderModifier)
	-- Set the default shell to PowerShell
	-- If you want to use a different shell, other options are:
	-- cmd.exe
	-- bash.exe (if you have WSL installed)
	config.default_prog = { "powershell.exe" }

	-- Font settings
	-- You may use any font installed on your system.
	-- If you want to use a specific font, you have available use the command:
	-- `wezterm ls-fonts --list-system` to list all available fonts.
	config.font = wezterm.font("Cascadia Code")
	config.font_size = 12.0
	config.line_height = 1.2

	-- Launcher settings
	config.launch_menu = {
		{
			label = "PowerShell",
			args = { "powershell.exe" },
		},
		{
			label = "Command Prompt",
			args = { "cmd.exe" },
		},
		{
			label = "Bash/WSL",
			args = { "bash.exe" },
		},
		{
			label = "NeoVim - WSL",
			args = { "wsl.exe", "nvim" },
		},
		{
			label = "VSCode - Windows",
			args = { "cmd.exe", "/C", "code", "." },
		},
	}

	-- Launcher key binding
	local launcherKeyBinds = {}
	TableConcat(config.keys, launcherKeyBinds)
end
---------------------------------------------------------------
-- Windows Configuration End
---------------------------------------------------------------

---------------------------------------------------------------
-- Linux Configuration
---------------------------------------------------------------
function linux_config(leader, leaderModifier)
	-- Set the default shell to bash
	-- If you want to use a different shell, other options are:
	-- /bin/zsh
	-- /bin/fish
	config.default_prog = { "/bin/bash" }

	-- Window settings
	-- I run a window manager and do not like having a title bar
	-- If you want to re-enable the title bar, set this to "RESIZE | TITLE"
	config.window_decorations = "RESIZE"

	-- Font settings
	-- You may use any font installed on your system.
	-- If you want to use a specific font, you have available use the command:
	-- `wezterm ls-fonts --list-system` to list all available fonts.
	-- config.font = wezterm.font("JetBrains Mono")
	-- config.font_size = 12.0
	-- config.line_height = 1.2
end
---------------------------------------------------------------
-- Linux Configuration End
---------------------------------------------------------------

---------------------------------------------------------------
-- Universal Configuration
---------------------------------------------------------------

-- This part of the config is universal and should work on all systems.
-- Other parts of the config are system specific and will be called as
-- lua functions at the end of this section.

-- Set the color scheme for the terminal
-- More theemes can be found at: https://wezterm.org/colorschemes/
-- Here are a few I like to get started with:
-- config.color_scheme = "s3r0 modified (terminal.sexy)"
-- config.color_scheme = "rebecca"
-- config.color_scheme = "Relaxed"
config.color_scheme = "Rippedcasts"

-- Here you can overide some colors from a theme if you need
-- https://wezterm.org/config/appearance.html#precedence-of-colors-vs-color_schemes
config.colors = {
	-- Ex:
	-- background = "#92e8a9",
	-- split = "blue",
}

-- Disable the terminal bell
config.audible_bell = "Disabled"

-- Set the opacity of the terminal window
config.window_background_opacity = 0.9

-- Tab bar settings
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true

-- Terminal Padding
-- This is used to controll the padding between the window and terminal cells
-- Generally this should not need to be modified

config.window_padding = {
	bottom = 0,
	top = 0,
	left = 20,
	right = 0,
}

-- Window background image
-- Uncomment the line below to set a background image for the terminal window
-- config.window_background_image = '/path/to/your/image.jpg'

-- Key bindings
-- Uses ALT as the default key used to prefix the key bindings.
local leader = "ALT"
-- Used if there is a need a key in addition to the leader key.
local leaderModifier = "SHIFT"
config.keys = {
	------------------
	-- Pane management
	------------------
	-- Split the window horizontally
	{ key = "h", mods = leader, action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- Split the window vertically
	{ key = "v", mods = leader, action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- Close a pane
	{ key = "q", mods = leader, action = wezterm.action.CloseCurrentPane({ confirm = false }) },

	------------------
	-- Pane Navigation
	------------------
	{ key = "a", mods = leader, action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "d", mods = leader, action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "w", mods = leader, action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "s", mods = leader, action = wezterm.action.ActivatePaneDirection("Down") },

	------------------
	-- Copy and Paste
	------------------
	-- Copy the selected text to the clipboard
	{ key = "c", mods = leader, action = wezterm.action.CopyTo("Clipboard") },
	-- Paste the text from the clipboard
	{ key = "p", mods = leader, action = wezterm.action.PasteFrom("Clipboard") },

	---------------------
	-- Other Key Bindings
	---------------------
	-- Reload the configuration file
	{ key = "r", mods = leader .. "|" .. leaderModifier, action = wezterm.action.ReloadConfiguration },
	-- Open the wezterm launcher menu
	{ key = "l", mods = leader, action = wezterm.action.ShowLauncher },
}

-- Runs the windows config if the OS is Windows
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	windows_config(leader, leaderModifier)
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	linux_config(leader, leaderModifier)
end
---------------------------------------------------------------
-- Universal Configuration End
---------------------------------------------------------------

-- and finally, return the configuration to wezterm
return config
