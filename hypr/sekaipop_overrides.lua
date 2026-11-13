hl.layer_rule({ name = "sekaipop-region-no-anim", match = { namespace = "^sekaipop-region$" }, no_anim = true }) -- sekaipop:region-no-anim
hl.layer_rule({ name = "sekaipop-region-preview-no-anim", match = { namespace = "^sekaipop-region-preview$" }, no_anim = true }) -- sekaipop:region-preview-no-anim
hl.animation({ leaf = "workspaces", enabled = true, speed = 7.00, bezier = "menu_decel", style = "slide" }) -- sekaipop:hypr:animation.workspaces
hl.config({ ["general"] = { ["layout"] = [==[dwindle]==] } }) -- sekaipop:hypr:general.layout
-- sekaipop:keys:begin  (the keybinds panel writes this part; change keys there)
-- sekaipop:keys {"overview":{"unbind":[{"mods":64,"key":"Tab","took":false}],"bind":[{"mods":64,"key":"O"}],"cmd":"qs -c sekaipop ipc call overview toggle","locked":false}}
pcall(hl.unbind, [==[SUPER + Tab]==])
pcall(hl.bind, [==[SUPER + O]==], hl.dsp.exec_cmd([==[qs -c sekaipop ipc call overview toggle]==]), { description = [==[Shell: Toggle overview]==] })
-- sekaipop:keys:end
pcall(hl.config, { ["general"] = { ["col"] = { ["active_border"] = "rgba(9cb4ffee)", ["inactive_border"] = "rgba(344a84cc)" } } }) -- sekaipop:apptheme:hyprland
