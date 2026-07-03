-- hyprland.lua — entry point
-- Ported from hyprland.conf (hyprlang) to Lua for Hyprland 0.55+; split into modules 2026-05-24.
-- Hyprland loads this file in preference to hyprland.conf when both exist.
-- Each require() runs in a separate Lua scope, so a syntax error in one module
-- does not abort the others.
--
-- ROLLBACK: from a TTY (Ctrl+Alt+F2), run
--     mv ~/.config/hypr/hyprland.lua ~/.config/hypr/hyprland.lua.bak
--     mv ~/.config/hypr/.hyprland.conf ~/.config/hypr/hyprland.conf
-- and log back in. NOTE the second command: the legacy config is stored
-- as ".hyprland.conf" (leading dot), which Hyprland does NOT pick up —
-- it must be renamed to "hyprland.conf" for the fallback to work.
--
-- Modules (all flat in ~/.config/hypr/):
--   vars.lua       shortcut variables  (required by binds)
--   rose-pine.lua  color palette       (required by appearance)
--   system.lua     env + monitors + autostart
--   appearance.lua general/decoration/animations/curves + dwindle/master/misc/xwayland
--   input.lua      input + gesture
--   binds.lua      keybinds
--   rules.lua      window rules

require("system")
require("appearance")
require("input")
require("binds")
require("rules")
