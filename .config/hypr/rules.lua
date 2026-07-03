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

hl.layer_rule({
    match = { namespace = "vicinae" },
    name  = "vicinae-blur",
    blur  = true,
    ignore_alpha = 0,
})
