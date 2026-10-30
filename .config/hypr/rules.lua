-- rules.lua — window rules

hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "firefox-pip",
    match = { class = "firefox", title = ".*Picture-in-Picture.*" },
    float = true,
    pin   = true,
    size  = "30% 30%",
    move  = "69% 67%",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

-- Hidden window for the Flipper dispatcher (SUPER+ALT+P)
hl.window_rule({
    name  = "flipper-dispatcher",
    match = { class = "^flipperpad$" },
    float = true,
    size  = "1 1",
    move  = "1918 1198",
})

hl.layer_rule({
    match = { namespace = "vicinae" },
    name  = "vicinae-blur",
    blur  = true,
    ignore_alpha = 0,
})

-- Keep Hyprland binds working over Greenlight
hl.window_rule({
    name                 = "greenlight-keep-binds",
    match                = { class = "(?i)^greenlight.*" },
    no_shortcuts_inhibit = true,
})
