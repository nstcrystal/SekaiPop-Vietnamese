
-- Keybinds. Shell binds call `qs -c sekaipop ipc call <target> <function>` (QS_IPC, variables.lua).
-- The shell's cheat sheet (ipc call cheatsheet toggle) reads them back from Hyprland. Hyprland's
-- Lua config reports every bind as "__lua", so the cheat sheet can only know what a bind is from
-- its description, written as "Group: sentence":
--     Shell, Utilities, Windows, Workspaces, Session, Screen, Media, Apps
--   "Windows: Close window"        -> shown in the Windows note as "Close window"
--   "Windows (more): Close window" -> same, but only after "+N more" (alternate keys and extras)
-- Binds with the same group, modifiers and sentence fold into one row (the four arrows, 1..0).
-- Hardware keys (XF86...) need no description: the cheat sheet names them by the key.
-- Add or change binds in custom/keybinds.lua, not here. SekaiPop's own binds can also be
-- changed in the keybinds panel (Settings > Hyprland > Keybinds), which writes its changes to sekaipop_overrides.lua; it finds
-- them by these descriptions, so keep the sentences as they are.

local ipcCall = QS_IPC

-- Shorthand for a shell bind (more = true: listed under "+N more" only)
local function shell(keys, call, description, more)
    hl.bind(keys, hl.dsp.exec_cmd(ipcCall .. call),
        { description = (more and "Shell (more): " or "Shell: ") .. description })
end

--##! Shell
-- A bare Super tap: the shell's one GlobalShortcut (Apps screen of the phone).
-- release = true is what makes it a tap: Hyprland skips a release bind when another bind
-- ran while Super was held. Without it, Hyprland 0.57 sends the shortcut's release after
-- SUPER + N, SUPER + W and every other Super bind, and each of them opened Apps too (issue #99).



-- hl.bind("SUPER + SUPER_L", hl.dsp.global("quickshell:searchToggleRelease"), { release = true, description = "Shell: Apps" })
-- hl.bind("SUPER + SUPER_R", hl.dsp.global("quickshell:searchToggleRelease"), { release = true, description = "Shell (more): Apps" })


shell("SUPER + A", "launcherphone toggle", "Toggle apps")
shell("SUPER + N", "quickpanel toggle", "Toggle quick panel")
shell("SUPER + O", "overview toggle", "Toggle overview")
shell("SUPER + I", "settings toggle", "Toggle settings")
shell("SUPER + Slash", "cheatsheet toggle", "Toggle cheatsheet")
shell("SUPER + K", "keyboard toggle", "Toggle on-screen keyboard")
shell("SUPER + M", "eq open", "Toggle equalizer")
shell("SUPER + G", "gamemode toggle", "Toggle game mode")

shell("SUPER + SHIFT + E", "presets toggle", "Edit desktop")
-- shell("SUPER + SHIFT + E", "desktopedit toggle", "Edit desktop")

shell("SUPER + SHIFT + F", "focus toggle", "Toggle focus mode")
shell("SUPER + SHIFT + ALT + Slash", "welcome show", "Welcome tour", true)
shell("SUPER + Escape", "phone go power", "Toggle power options")

-- Look
shell("SUPER + W", "wallpaperpicker toggle", "Change wallpaper")
shell("SUPER + SHIFT + W", "wallpaper random", "Random wallpaper", true)
-- shell("CTRL + SUPER + SHIFT + T", "theme toggle", "Toggle theme picker")
-- shell("CTRL + SUPER + SHIFT + D", "theme darkToggle", "Toggle dark mode")

-- Restart the shell. Only one shell may run at a time (its GlobalShortcut registers once),
-- so the old one is stopped before the new one starts.
hl.bind("CTRL + SUPER + R",
    hl.dsp.exec_cmd("pkill -x qs; pkill -x quickshell; sleep 0.5; setsid " .. QS .. " >/dev/null 2>&1 &"),
    { description = "Shell: Restart shell" })

-- Volume and brightness go through the shell so its on-screen display shows them;
-- wpctl / brightnessctl take over if the shell is not running.

-- Brightness: SUPER + F3 (giảm), SUPER + F4 (tăng)
-- Các phím hardware XF86MonBrightness đã comment vì dùng SUPER+F3/F4 thay thế.
-- Bỏ comment nếu muốn dùng lại phím hardware.
-- hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipcCall .. "osd brightnessUp || brightnessctl s 5%+"),
--     { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipcCall .. "osd brightnessDown || brightnessctl s 5%-"),
--     { locked = true, repeating = true })
hl.bind("SUPER + F3", hl.dsp.exec_cmd(ipcCall .. "osd brightnessDown || brightnessctl s 5%-"),
    { locked = true, repeating = true, description = "Media: Brightness Down" })
hl.bind("SUPER + F4", hl.dsp.exec_cmd(ipcCall .. "osd brightnessUp || brightnessctl s 5%+"),
    { locked = true, repeating = true, description = "Media: Brightness Up" })

-- Volume: SUPER + F7 (giảm), SUPER + F8 (tăng)
-- Các phím hardware XF86Audio đã comment vì dùng SUPER+F7/F8 thay thế.
-- Bỏ comment nếu muốn dùng lại phím hardware.
-- hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipcCall .. "osd volumeUp || wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5"),
--     { locked = true, repeating = true })
-- hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipcCall .. "osd volumeDown || wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),
--     { locked = true, repeating = true })
hl.bind("SUPER + F7", hl.dsp.exec_cmd(QS_IPC .. "osd volumeDown || wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),
    { locked = true, repeating = true, description = "Media: Volume Down" })
hl.bind("SUPER + F8", hl.dsp.exec_cmd(QS_IPC .. "osd volumeUp || wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5"),
    { locked = true, repeating = true, description = "Media: Volume Up" })


--##! Utilities
--# Screenshot
--# Chỉ giữ 2 bind:
--#   Print            → chụp toàn màn hình → clipboard
--#   SUPER + Print    → chụp vùng chọn (region picker) → clipboard
--# Các bind khác (OCR, record, Google Lens, save-to-file) đã comment.
--# Bỏ comment từng dòng nếu muốn dùng lại.

--# Chụp vùng chọn → clipboard
local grimhyprctl = "grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\""
hl.bind("SUPER + Print", hl.dsp.exec_cmd(ipcCall .. "region screenshot || grim -g \"$(slurp)\" - | wl-copy"),
    { description = "Utilities: Screen snip" })

--# Chụp vùng chọn → file (đã comment — dùng SUPER+Print thay thế)
-- hl.bind("CTRL + SUPER + SHIFT + S", hl.dsp.exec_cmd(ipcCall .. "region save"),
--     { description = "Utilities: Screen snip >> file" })

--# OCR — nhận dạng ký tự từ vùng chọn → clipboard (đã comment)
-- hl.bind("SUPER + SHIFT + X", hl.dsp.exec_cmd(ipcCall .. "region ocr"),
--     { description = "Utilities: Character recognition >> clipboard" })

--# Google Lens — tìm kiếm bằng vùng chọn (đã comment)
-- hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd(ipcCall .. "region search"),
--     { description = "Utilities: Google Lens" })

--# Quay màn hình không tiếng (đã comment)
-- hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd(ipcCall .. "region toggleRecord"),
--     { locked = true, description = "Utilities: Record region (no sound)" })

--# Quay màn hình có tiếng (đã comment)
-- hl.bind("SUPER + SHIFT + ALT + R", hl.dsp.exec_cmd(ipcCall .. "region recordSound"),
--     { locked = true, description = "Utilities: Record region (with sound)" })

--# Color picker
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"),
    { description = "Utilities: Pick color #RRGGBB >> clipboard" })

--# Clipboard history và emoji
hl.bind("SUPER + V", hl.dsp.exec_cmd(ipcCall .. "launcherphone toggleMode clip"),
    { description = "Utilities: Clipboard history" })
hl.bind("SUPER + Period", hl.dsp.exec_cmd(ipcCall .. "launcherphone toggleMode emoji"),
    { description = "Utilities: Emoji >> clipboard" })

--# Chụp toàn màn hình → clipboard
hl.bind("Print", hl.dsp.exec_cmd(grimhyprctl .. " - | wl-copy"),
    { locked = true, description = "Utilities: Screenshot >> clipboard" })

--# Chụp toàn màn hình → clipboard & file (đã comment — dùng Print thay thế)
-- hl.bind("CTRL + Print", hl.dsp.exec_cmd(
--     "mkdir -p $(xdg-user-dir PICTURES)/Screenshots && " ..
--     grimhyprctl .. " - | tee $(xdg-user-dir PICTURES)/Screenshots/Screenshot_\"$(date '+%Y-%m-%d_%H.%M.%S')\".png | wl-copy"
-- ), { locked = true, description = "Utilities: Screenshot >> clipboard & file" })

-- Test notifications (popups, the phone, actions) have no key: run
-- ~/.config/hypr/hyprland/scripts/notify-test.sh image | actions | urgent


--##! Screen
--# Zoom
local function zoomfunction(value)
    local zoomvalue = hl.get_config("cursor:zoom_factor")
    if (zoomvalue + value) > 3.0 then
        hl.config({ cursor = { zoom_factor = 3.0 } })
    elseif (zoomvalue + value) < 1.0 then
        hl.config({ cursor = { zoom_factor = 1.0 } })
    else
        hl.config({ cursor = { zoom_factor = zoomvalue + value } })
    end
end
hl.bind("SUPER + Minus", function() zoomfunction(-0.3) end, { repeating = true, description = "Screen: Zoom out" })
hl.bind("SUPER + Equal", function() zoomfunction(0.3) end, { repeating = true, description = "Screen: Zoom in" })


--##! Media (playerctl: the shell reads players itself, but has no IPC to drive them)
local mediaNextCommand =
"playerctl next || playerctl position `bc <<< \"100 * $(playerctl metadata mpris:length) / 1000000 / 100\"`"
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(mediaNextCommand), { locked = true, description = "Media: Next track" })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(mediaNextCommand), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("SUPER + SHIFT + ALT + mouse:275", hl.dsp.exec_cmd("playerctl previous"),
    { description = "Media (more): Previous track" })
hl.bind("SUPER + SHIFT + ALT + mouse:276", hl.dsp.exec_cmd(mediaNextCommand),
    { description = "Media (more): Next track" })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("playerctl previous"),
    { locked = true, description = "Media: Previous track" })
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("playerctl play-pause"),
    { locked = true, description = "Media: Play/pause media" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipcCall .. "osd toggleMute || wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
--     { locked = true })
hl.bind("SUPER + F6", hl.dsp.exec_cmd(ipcCall .. "osd toggleMute || wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, description = "Media: Toggle mute" })
-- hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipcCall .. "osd toggleMicMute || wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
--     { locked = true })

-- ALT + XF86AudioMute đã comment vì SUPER+F5 đã thay thế
-- hl.bind("ALT + XF86AudioMute", hl.dsp.exec_cmd(ipcCall .. "osd toggleMicMute || wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
--     { locked = true, description = "Media (more): Toggle mic" })
hl.bind("SUPER + F5", hl.dsp.exec_cmd(ipcCall .. "osd toggleMicMute || wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, description = "Media: Toggle mic" })


--##! Window
--# Focusing
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Windows: Move window" })
-- SUPER + mouse:274 (chuột giữa) trùng với chuột trái, đã comment
-- hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true, description = "Windows (more): Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Windows: Resize window" })

--#/# bind = SUPER + ←/↑/→/↓ — Focus cửa sổ theo hướng
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }),
        { description = "Windows: Focus window in direction" })
end


-- SUPER + [/] trùng với SUPER + ←/→, đã comment
-- for i = 1, 2 do
--     local arrowkey = { "BracketLeft", "BracketRight" }
--     local focusdir = { "l", "r" }
--     hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }),
--         { description = "Windows (more): Focus window left/right" })
-- end

--#/# bind = SUPER + SHIFT + ←/↑/→/↓ — Di chuyển cửa sổ theo hướng (tiling)
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + SHIFT + " .. arrowkey[i], hl.dsp.window.move({ direction = focusdir[i] }),
        { description = "Windows: Move window in direction" })
end

hl.bind("ALT + F4",
    function()
        hl.exec_cmd(
            "notify-send \"Wrong close keybind\" \"Super+Q to close. Use Alt+F4 for Windows VMs\" -a Hyprland")
    end,
    { non_consuming = true, description = "Windows (more): Alt+F4 only shows a reminder (Super+Q closes)" })
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Windows: Close window" })
hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"), { description = "Windows: Forcefully zap a window" })

--# Window split ratio
hl.bind("SUPER + Semicolon", hl.dsp.layout("splitratio -0.1"),
    { repeating = true, description = "Windows: Adjust split ratio" })
hl.bind("SUPER + Apostrophe", hl.dsp.layout("splitratio +0.1"),
    { repeating = true, description = "Windows: Adjust split ratio" })

--# Positioning mode
-- hl.bind("SUPER + D", hl.dsp.window.float({ action = "toggle" }), { description = "Windows: Float/Tile" })
hl.bind("SUPER + D", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
    hl.dispatch(hl.dsp.window.resize({ x = 1000, y = 700 }))
    hl.dispatch(hl.dsp.window.center())
end, { description = "Windows: Float/Tile" })

-- hl.bind("SUPER + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }),
--     { description = "Windows: Maximize" })

hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }),
    { description = "Windows: Fullscreen" })
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen_state({ internal = 0, client = 3, action = "toggle" }),
    { description = "Windows: Fullscreen spoof" })
hl.bind("SUPER + P", hl.dsp.window.pin(), { description = "Windows: Pin window" })

--# Send to workspace (1..10) và chuyển sang workspace đó luôn (follow = true).
--# Phím: SUPER + SHIFT + 1..0
--# Nếu layout không có số 1..0 ở đúng vị trí, thêm bind `SUPER + SHIFT + code:10`.. vào custom/keybinds.lua (`wev` in ra codes).
for i = 1, 10 do
    hl.bind("SUPER + SHIFT + " .. (i % 10), function()
        hl.dispatch(hl.dsp.window.move({ workspace = i, follow = true }))
    end, { description = "Windows: Send to workspace # (1-10)" })
end

--# Send to workspace left/right — đã comment, dùng SUPER+SHIFT+1..0 thay thế.
--# Bỏ comment nếu muốn dùng lại.
-- for i = 1, 4 do
--     local key = { "SUPER + SHIFT + mouse_", "SUPER + ALT + mouse_" }
--     local keycombos = { key[1] .. "up", key[1] .. "down", key[2] .. "up", key[2] .. "down" }
--     local prefix = { "r-", "r+", "r-", "r+" }
--     hl.bind(keycombos[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }),
--         { description = "Windows (more): Send to workspace left/right" })
-- end
-- for i = 1, 2 do
--     local keydirs = { "Up", "Down" }
--     local prefix = { "r-", "r+" }
--     hl.bind("SUPER + SHIFT + Page_" .. keydirs[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }),
--         { description = "Windows: Send to workspace left/right" })
-- end
-- for i = 1, 4 do
--     local key = { "SUPER + ALT + Page_", "CTRL + SUPER + SHIFT + " }
--     local keycombos = { key[1] .. "Down", key[1] .. "Up", key[2] .. "Right", key[2] .. "Left" }
--     local prefix = { "r+", "r-", "r+", "r-" }
--     hl.bind(keycombos[i], hl.dsp.window.move({ workspace = prefix[i] .. "1" }),
--         { description = "Windows (more): Send to workspace left/right" })
-- end

--# Scratchpad
--# SUPER + SHIFT + S: gửi cửa sổ hiện tại vào scratchpad rồi mở scratchpad lên luôn.
--#   Mỗi lần nhấn đều gửi cửa sổ đang focus vào scratchpad và toggle nó lên.
hl.bind("SUPER + SHIFT + S", function()
    hl.dispatch(hl.dsp.window.move({ workspace = "special:special", follow = false }))
    hl.dispatch(hl.dsp.workspace.toggle_special("special"))
end, { description = "Windows: Send to scratchpad" })

--# SUPER + ALT + S — đã comment, gộp vào SUPER+SHIFT+S
-- hl.bind("SUPER + ALT + S",
--     hl.dsp.window.move({ workspace = "special:special", follow = true }),
--     { description = "Windows: Send to scratchpad" })

-- CTRL + SUPER + S — đã comment, trùng chức năng
-- hl.bind("CTRL + SUPER + S", hl.dsp.workspace.toggle_special("special"),
--     { description = "Workspaces (more): Toggle scratchpad" })


--##! Workspace
--# Switching — chỉ giữ SUPER+1..0 và SUPER+mouse_down/up.
--# Các cách chuyển workspace khác đã comment để tránh trùng lặp.
--# Bỏ comment nếu muốn dùng lại.

--# Chuyển trực tiếp đến workspace 1–10
for i = 1, 10 do
    hl.bind("SUPER + " .. (i % 10), function()
        hl.dispatch(hl.dsp.focus({ workspace = i }))
    end, { description = "Workspaces: Focus workspace # (1-10)" })
end

--# CTRL + SUPER + ←/→ — đã comment, dùng SUPER+mouse scroll thay thế
-- for i = 1, 2 do
--     local keys = { "Left", "Right" }
--     local prefix = { "r-", "r+" }
--     hl.bind("CTRL + SUPER + " .. keys[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }),
--         { description = "Workspaces: Focus workspace left/right" })
-- end

--# CTRL + SUPER + ALT + ←/→ (theo monitor) — đã comment
-- for i = 1, 2 do
--     local keys = { "Left", "Right" }
--     local prefix = { "m-", "m+" }
--     hl.bind("CTRL + SUPER + ALT + " .. keys[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }),
--         { description = "Workspaces (more): Focus workspace left/right (this monitor)" })
-- end

--# SUPER + PageDown/Up và CTRL + SUPER + PageDown/Up — đã comment
-- for i = 1, 4 do
--     local key = { "SUPER + Page_Down", "SUPER + Page_Up" }
--     local keycombos = { key[1], key[2], "CTRL + " .. key[1], "CTRL + " .. key[2] }
--     local prefix = { "r+", "r-", "r+", "r-" }
--     hl.bind(keycombos[i], hl.dsp.focus({ workspace = prefix[i] .. "1" }),
--         { description = (i <= 2) and "Workspaces: Focus workspace left/right"
--             or "Workspaces (more): Focus workspace left/right" })
-- end

--# Hàm chuyển workspace với wrap-around trong khoảng 1–10.
--# Dùng chung cho TAB, SHIFT+TAB và cuộn chuột.
--# direction = 1: tiến (1→2→...→10→1), direction = -1: lùi (1→10→...→2→1)
local function switchWorkspace(direction)
    local current = hl.get_active_workspace().id
    -- Bỏ qua nếu đang ở special workspace (id âm hoặc ngoài 1–10)
    if current < 1 or current > 10 then return end
    local next = current + direction
    if next > 10 then next = 1 end
    if next < 1 then next = 10 end
    hl.dispatch(hl.dsp.focus({ workspace = next }))
end

--# SUPER + mouse_down/up — cuộn chuột chuyển workspace với wrap-around
--# CTRL + SUPER + mouse_down/up — đã comment, trùng chức năng
-- hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "r+1" }),
--     { description = "Workspaces (more): Focus workspace left/right" })
-- hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "r-1" }),
--     { description = "Workspaces (more): Focus workspace left/right" })
hl.bind("SUPER + mouse_down", function() switchWorkspace(1) end,
    { description = "Workspaces: Next workspace (wrap)" })
hl.bind("SUPER + mouse_up", function() switchWorkspace(-1) end,
    { description = "Workspaces: Previous workspace (wrap)" })

--# SUPER + Tab / SUPER + SHIFT + Tab — chuyển workspace tiếp/trước với wrap-around
hl.bind("SUPER + Tab", function() switchWorkspace(1) end,
    { description = "Workspaces: Next workspace (wrap)" })
hl.bind("SUPER + SHIFT + Tab", function() switchWorkspace(-1) end,
    { description = "Workspaces: Previous workspace (wrap)" })

--# CTRL + SUPER + [/] và CTRL + SUPER + ↑/↓ (nhảy 5) — đã comment
-- for i = 1, 4 do
--     local key = { "BracketLeft", "BracketRight", "Up", "Down" }
--     local prefix = { "-1", "+1", "r-5", "r+5" }
--     hl.bind("CTRL + SUPER + " .. key[i], hl.dsp.focus({ workspace = prefix[i] }),
--         { description = (i <= 2) and "Workspaces (more): Focus previous/next workspace"
--             or "Workspaces (more): Jump 5 workspaces" })
-- end

--## Special / Scratchpad
--# SUPER + S: toggle scratchpad (xem/ẩn, không gửi cửa sổ)
--# SUPER + SHIFT + S: gửi cửa sổ hiện tại vào scratchpad rồi mở lên (xem block Windows phía trên)
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("special"),
    { description = "Workspaces: Toggle scratchpad" })
-- SUPER + mouse:275 — đã comment, dùng SUPER+S thay thế
-- hl.bind("SUPER + mouse:275", hl.dsp.workspace.toggle_special("special"),
--     { description = "Workspaces (more): Toggle scratchpad" })


--##! Virtual machines
hl.define_submap("virtual-machine", function()
    hl.bind("SUPER + ALT + F1", function()
        local currentsubmap = hl.get_current_submap()
        if currentsubmap == "virtual-machine" then
            hl.dispatch(hl.dsp.exec_cmd(
                "notify-send 'Exited Virtual Machine submap' 'Keybinds re-enabled' -a 'Hyprland'"))
            hl.dispatch(hl.dsp.submap("reset"))
        elseif currentsubmap == "" then
            hl.dispatch(hl.dsp.exec_cmd(
                "notify-send 'Entered Virtual Machine submap' 'Keybinds disabled. hit SUPER+ALT+F1 to escape' -a 'Hyprland'"))
            hl.dispatch(hl.dsp.submap("virtual-machine"))
        end
    end, { submap_universal = true })
end)


--##! Session
-- Lock là lockscreen của shell (hypridle.conf's lock_cmd cũng gọi nó).
-- loginctl là fallback nếu shell không chạy.
hl.bind("SUPER + L", hl.dsp.exec_cmd(ipcCall .. "lock lock || loginctl lock-session"),
    { description = "Session: Lock screen" })
hl.bind("SUPER + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend || loginctl suspend"),
    { locked = true, description = "Session: Sleep" })
hl.bind("CTRL + SHIFT + ALT + SUPER + Delete", hl.dsp.exec_cmd("systemctl poweroff || loginctl poweroff"),
    { description = "Session: Power off" })


--##! Apps
hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal), { description = "Apps: Terminal" })
-- hl.bind("SUPER + T", hl.dsp.exec_cmd(terminal), { description = "Apps (more): Terminal" })
-- hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd(terminal), { description = "Apps (more): Terminal" })
hl.bind("SUPER + E", hl.dsp.exec_cmd(fileManager), { description = "Apps: File manager" })
hl.bind("SUPER + B", hl.dsp.exec_cmd(browser), { description = "Apps: Browser" })
hl.bind("SUPER + C", hl.dsp.exec_cmd(codeEditor), { description = "Apps: Code editor" })
hl.bind("CTRL + SUPER + SHIFT + ALT + W", hl.dsp.exec_cmd(officeSoftware), { description = "Apps: Office software" })
hl.bind("SUPER + X", hl.dsp.exec_cmd(textEditor), { description = "Apps: Text editor" })
hl.bind("CTRL + SUPER + V", hl.dsp.exec_cmd(volumeMixer), { description = "Apps: Volume mixer" })
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd(taskManager), { description = "Apps: Task manager" })

-- Shell IPC with no key yet. Copy a line into custom/keybinds.lua and change the keys:
--   hl.bind("SUPER + ALT + C", hl.dsp.exec_cmd(QS_IPC .. "clock nextDesign"), { description = "Shell: Next clock design" })
--   hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd(QS_IPC .. "visualizer toggle"), { description = "Shell: Toggle visualizer" })
--   hl.bind("SUPER + ALT + W", hl.dsp.exec_cmd(QS_IPC .. "weathercard toggle"), { description = "Shell: Toggle weather card" })
--   hl.bind("SUPER + ALT + D", hl.dsp.exec_cmd(QS_IPC .. "discord mute"), { description = "Shell: Discord mute" })
--   hl.bind("SUPER + ALT + P", hl.dsp.exec_cmd(QS_IPC .. "presets toggle"), { description = "Shell: Desktop presets" })
--   hl.bind("SUPER + B", hl.dsp.exec_cmd(QS_IPC .. "bar toggle"), { description = "Shell: Toggle bar" })
--   hl.bind("SUPER + ALT + A", hl.dsp.exec_cmd(QS_IPC .. "quickpanel keepAwake"), { description = "Shell: Toggle Keep Awake" })
