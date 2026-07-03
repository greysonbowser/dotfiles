-- system.lua — environment variables, monitors, and autostart

-- Env variables (set before the display server initializes)
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Monitors
hl.monitor({ output = "eDP-1",    mode = "preferred", position = "auto",   scale = 1.5, mirror = "HDMI-A-1" })
hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0",    scale = 1 })
hl.monitor({ output = "DP-2",     mode = "preferred", position = "1920x0", scale = 1 })

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpanel")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("vicinae server")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("/usr/local/bin/substd")
    hl.exec_cmd("fish -lc 'gambitbot_start'")
end)
