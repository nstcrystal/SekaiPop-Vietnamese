hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Shell (more): Edit user keybinds"} )

--  -- Volume: SUPER + F7 (tăng), SUPER + F8 (giảm)
--  hl.bind("SUPER + F7", hl.dsp.exec_cmd(QS_IPC .. "osd volumeDown || wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"),
--  { locked = true, repeating = true })
--  hl.bind("SUPER + F8", hl.dsp.exec_cmd(QS_IPC .. "osd volumeUp || wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%+ -l 1.5"),
--      { locked = true, repeating = true })