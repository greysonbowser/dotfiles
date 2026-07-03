-- keybindings
local vars        = require("vars")
local mainMod     = vars.mainMod
local terminal    = vars.terminal
local fileManager = vars.fileManager
local browser     = vars.browser
local menu        = vars.menu
local pipScript   = "/home/grey/.config/hypr/scripts/pip"

hl.bind(mainMod .. " + F",      hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind("Print",                hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + Y",      hl.dsp.exec_cmd(pipScript))
-- workspaceopt has no Lua dispatcher; emulate the allfloat toggle per workspace.
-- Unlike the old workspaceopt, this only affects existing windows, not ones
-- opened while the mode is active.
local allfloat = {}
hl.bind(mainMod .. " + SHIFT + Y", function()
    local ws = hl.get_active_workspace()
    if not ws then return end
    local target = not allfloat[ws.id]
    allfloat[ws.id] = target
    for _, w in ipairs(hl.get_workspace_windows(ws)) do
        if w.floating ~= target then
            hl.dispatch(hl.dsp.window.float({ window = w }))
        end
    end
end)
hl.bind(mainMod .. " + space",  hl.dsp.exec_cmd(menu .. " toggle"))
hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("pkill -SIGUSR1 wayscriber"))
hl.bind(mainMod .. " + D",      hl.dsp.exec_cmd("fish -lc dic-lookup"))
hl.bind(mainMod .. " + L",      hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind(mainMod .. " + N",      hl.dsp.exec_cmd([[sh -c '
f=/tmp/hyprsunset-stage
s=$(cat "$f" 2>/dev/null || echo 0)
case "$s" in
    0) hyprctl hyprsunset temperature 3500; echo 1 > "$f" ;;
    1) hyprctl hyprsunset temperature 2500; echo 2 > "$f" ;;
    *) hyprctl hyprsunset identity;         echo 0 > "$f" ;;
esac']]))

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "d" }))

for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- for laptop media keys (was: bindel = repeat + locked)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { repeating = true, locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { repeating = true, locked = true })

-- (was: bindl = locked)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
