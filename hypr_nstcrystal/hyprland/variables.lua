-- Default variables. Override them in ~/.config/hypr/custom/variables.lua.

-- The folder inside ~/.config/quickshell that holds the shell.
qsConfig = "sekaipop"
hl.env("qsConfig", qsConfig) -- for custom files and scripts that still say $qsConfig

-- `qs -c sekaipop ipc call <target> <function>`: how every shell keybind talks to the shell.
QS = "qs -c " .. qsConfig
QS_IPC = QS .. " ipc call "

local launch = "~/.config/hypr/hyprland/scripts/launch_first_available.sh"

-- Terminal. $TERMINAL wins if you already export it; otherwise the first installed of this
-- list. It is also exported as $TERMINAL (env.lua), which the shell tries before its own list,
-- so SUPER+Enter and the shell's "open in a terminal" actions open the same one.
local terminalList = { "kitty", "foot" }
local envTerminal = os.getenv("TERMINAL")
if envTerminal and envTerminal ~= "" then
    terminalName = envTerminal
else
    terminalName = first_available(terminalList)
end
terminal = terminalName or (launch .. " 'foot' 'kitty' 'alacritty' 'wezterm' 'konsole' 'xterm'")

-- Apps (the first one installed is launched)
fileManager = launch .. " 'thunar' 'dolphin' 'nautilus'"
browser = launch .. " 'google-chrome-stable' 'firefox'"
codeEditor = launch .. " 'code'"
officeSoftware = launch .. " 'libreoffice'"
textEditor = launch .. " 'kate' 'gnome-text-editor' 'emacs'"
volumeMixer = launch .. " 'pavucontrol-qt' 'pavucontrol'"
-- Same order the shell uses for its own system-monitor button.
taskManager = launch .. " 'plasma-systemmonitor --page-name Processes' 'command -v btop && " .. (terminalName or "xterm") .. " -e btop'"

-- Cursor used until the shell restores the one you picked in Settings (it does that a moment
-- after it starts). Only a fallback for a fresh install.
cursorTheme = "Bibata-Modern-Classic"
cursorSize = 20
