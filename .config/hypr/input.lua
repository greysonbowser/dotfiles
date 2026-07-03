-- input.lua — input devices and gestures

hl.config({
    input = {
        kb_layout          = "us",
        numlock_by_default = true,
        follow_mouse       = 1,
        sensitivity        = 0,
        kb_options         = "caps:swapescape",
        touchpad = {
            natural_scroll = true,
        },
    },
})

-- was: gesture = 3, horizontal, workspace
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})
