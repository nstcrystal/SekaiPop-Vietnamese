hl.layer_rule({ name = "sekaipop-region-no-anim", match = { namespace = "^sekaipop-region$" }, no_anim = true }) -- sekaipop:region-no-anim
hl.layer_rule({ name = "sekaipop-region-preview-no-anim", match = { namespace = "^sekaipop-region-preview$" }, no_anim = true }) -- sekaipop:region-preview-no-anim
hl.config({ ["general"] = { ["gaps_in"] = 5 } }) -- sekaipop:hypr:general.gaps_in
hl.config({ ["decoration"] = { ["inactive_opacity"] = 1.00 } }) -- sekaipop:hypr:decoration.inactive_opacity
hl.config({ ["decoration"] = { ["active_opacity"] = 1.00 } }) -- sekaipop:hypr:decoration.active_opacity
hl.config({ ["misc"] = { ["disable_hyprland_logo"] = true } }) -- sekaipop:hypr:misc.disable_hyprland_logo
hl.animation({ leaf = "workspaces", enabled = true, speed = 7.00, bezier = "menu_decel", style = "slide" }) -- sekaipop:hypr:animation.workspaces
hl.config({ ["misc"] = { ["enable_swallow"] = false } }) -- sekaipop:hypr:misc.enable_swallow
hl.config({ ["misc"] = { ["animate_manual_resizes"] = false } }) -- sekaipop:hypr:misc.animate_manual_resizes
hl.config({ ["binds"] = { ["workspace_back_and_forth"] = true } }) -- sekaipop:hypr:binds.workspace_back_and_forth
hl.config({ ["binds"] = { ["allow_workspace_cycles"] = true } }) -- sekaipop:hypr:binds.allow_workspace_cycles
hl.config({ ["misc"] = { ["close_special_on_empty"] = true } }) -- sekaipop:hypr:misc.close_special_on_empty
hl.config({ ["dwindle"] = { ["preserve_split"] = true } }) -- sekaipop:hypr:dwindle.preserve_split
hl.config({ ["general"] = { ["layout"] = [==[dwindle]==] } }) -- sekaipop:hypr:general.layout
-- sekaipop:keys:begin  (the keybinds panel writes this part; change keys there)
-- sekaipop:keys {"launcherphone":{"unbind":[{"mods":64,"key":"A","took":false}],"bind":[{"mods":64,"key":"J"}],"cmd":"qs -c sekaipop ipc call launcherphone toggle","locked":false}}
pcall(hl.unbind, [==[SUPER + A]==])
pcall(hl.bind, [==[SUPER + J]==], hl.dsp.exec_cmd([==[qs -c sekaipop ipc call launcherphone toggle]==]), { description = [==[Shell: Toggle apps]==] })
-- sekaipop:keys:end
pcall(hl.config, { ["general"] = { ["col"] = { ["active_border"] = "rgba(bea9ffee)", ["inactive_border"] = "rgba(514184cc)" } } }) -- sekaipop:apptheme:hyprland
