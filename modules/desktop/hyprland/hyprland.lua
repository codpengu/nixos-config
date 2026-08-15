-- Hyprland Lua configuration


hl.config({
    misc = {
        disable_hyprland_logo = true,
        animate_mouse_windowdragging = false,
        animate_manual_resizes = false,
    },
})

hl.config({
    debug = {
        vfr = true,
    },
})

hl.config({
    cursor = {
        no_hardware_cursors = 1,
    },
})

-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/

hl.config({
    input = {
        kb_layout = "pl",
        follow_mouse = 4,
        touchpad = {
            natural_scroll = false,
        },
        sensitivity = 0,
        -- -1.0 - 1.0, 0 means no modification.
    },
})

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 5,
        border_size = 2,
        layout = "dwindle",
        col = {
            active_border = "rgb(FFF0F5)",
            inactive_border = "rgba(595959aa)",
        },
    },
})

hl.config({
    decoration = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 10,
        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            new_optimizations = true,
        },
        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },
    },
})

hl.config({
    animations = {
        enabled = false,
    },
})

hl.animation({ leaf = "border",    enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "fade",      enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "windows",   enabled = true, speed = 3, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "default", style = "slide" })

hl.config({
    dwindle = {
        preserve_split = true,
        force_split = 2,
        use_active_for_splits = false,
    },
})

-- Example per-device config

-- See https://wiki.hyprland.org/Configuring/Keywords/#executing for more

-- device:epic mouse V1 {

--     sensitivity = -0.5

-- }

-- Example windowrule v1

-- windowrule = float, ^(kitty)$

-- Example windowrule v2

-- windowrulev2 = float,class:^(kitty)$,title:^(kitty)$

-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more

local mainMod = "SUPER"

local mainModShift = "SUPER + SHIFT"

-- Fix jetbrains

hl.window_rule({
    match = {
        xwayland = true,
        float = true,
    },
    rounding = 0,
})

hl.window_rule({
    match = {
        class = "^(.*jetbrains.*)$",
        title = "^(Confirm Exit|Open Project|win424|splash)$",
    },
    center = true,
})

hl.window_rule({
    match = {
        class = "^(.*jetbrains.*)$",
        title = "^(splash)$",
    },
    size = { 640, 400 },
})

hl.window_rule({
    match = {
        float = false,
        class = "^(jetbrains-.*)",
        title = "^(win.*)",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(jetbrains-.*)",
        title = "^(Welcome to.*)",
    },
    float = true,
})

hl.window_rule({
    match = {
        class = "^(jetbrains-.*)",
        title = "^(Replace All)$",
    },
    center = true,
})

-- windowrule = forceinput,class ^(jetbrains-.*)

hl.window_rule({
    match = {
        class = "^(jetbrains-.*)",
    },
    no_anim = true,
})

-- windowrule = windowdance,class ^(jetbrains-.*) # allows IDE to move child windows

-- keepass

hl.window_rule({
    match = {
        class = "^(org.keepassxc.KeePassXC)$",
        title = "^(KeePassXC - Browser Access Request)$",
    },
    float = true,
})

-- flameshot

-- windowrule = noanim,class:^(flameshot)^,title:^(flameshot)^

-- bind = $mainMod, print, exec, flameshot gui

hl.bind(mainMod .. " + " .. "print", hl.dsp.exec_cmd("grimblast copy area"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "print", hl.dsp.exec_cmd("grimblast copy area && wl-paste| tesseract -l \"eng+pol\" stdin stdout| wl-copy && notify-send \"$(wl-paste)\""))

-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more

hl.bind(mainMod .. " + " .. "return", hl.dsp.exec_cmd("kitty zsh"))

-- bind = $mainMod, space, exec, ~/.config/rofi/launcher.sh

hl.bind(mainMod .. " + " .. "space", hl.dsp.exec_cmd("vicinae toggle"))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "E", hl.dsp.exit())

hl.bind(mainMod .. " + " .. "E", hl.dsp.exec_cmd("dolphin"))

hl.bind(mainMod .. " + " .. "Q", hl.dsp.window.close())

hl.bind(mainMod .. " + " .. "V", hl.dsp.window.float())

hl.bind(mainModShift .. " + " .. "J", hl.dsp.layout("togglesplit"))  -- dwindle (old layoutmsg had empty params)

-- dwindle

hl.bind(mainMod .. " + " .. "F", hl.dsp.window.fullscreen())

hl.bind(mainMod .. " + " .. "G", hl.dsp.group.toggle())

hl.bind(mainMod .. " + " .. "TAB", hl.dsp.group.next())

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. "TAB", hl.dsp.group.prev())

hl.bind(mainMod .. " + " .. "P", hl.dsp.window.pseudo())

-- dwindle

hl.bind(mainModShift .. " + " .. "Control_L", hl.dsp.exec_cmd("swaylock"))

-- Move focus with mainMod + arrow keys

hl.bind(mainMod .. " + " .. "h", hl.dsp.focus({ direction = "left" }))

hl.bind(mainMod .. " + " .. "l", hl.dsp.focus({ direction = "right" }))

hl.bind(mainMod .. " + " .. "k", hl.dsp.focus({ direction = "up" }))

hl.bind(mainMod .. " + " .. "j", hl.dsp.focus({ direction = "down" }))

-- Move window with mainMod + shift + arrow keys

hl.bind(mainModShift .. " + " .. "h", hl.dsp.window.move({ direction = "left" }))

hl.bind(mainModShift .. " + " .. "l", hl.dsp.window.move({ direction = "right" }))

hl.bind(mainModShift .. " + " .. "k", hl.dsp.window.move({ direction = "up" }))

hl.bind(mainModShift .. " + " .. "j", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]

hl.bind(mainMod .. " + " .. 1, hl.dsp.focus({ workspace = 1 }))

hl.bind(mainMod .. " + " .. 2, hl.dsp.focus({ workspace = 2 }))

hl.bind(mainMod .. " + " .. 3, hl.dsp.focus({ workspace = 3 }))

hl.bind(mainMod .. " + " .. 4, hl.dsp.focus({ workspace = 4 }))

hl.bind(mainMod .. " + " .. 5, hl.dsp.focus({ workspace = 5 }))

hl.bind(mainMod .. " + " .. 6, hl.dsp.focus({ workspace = 6 }))

hl.bind(mainMod .. " + " .. 7, hl.dsp.focus({ workspace = 7 }))

hl.bind(mainMod .. " + " .. 8, hl.dsp.focus({ workspace = 8 }))

hl.bind(mainMod .. " + " .. 9, hl.dsp.focus({ workspace = 9 }))

hl.bind(mainMod .. " + " .. 0, hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 1, hl.dsp.window.move({ workspace = 1 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 2, hl.dsp.window.move({ workspace = 2 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 3, hl.dsp.window.move({ workspace = 3 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 4, hl.dsp.window.move({ workspace = 4 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 5, hl.dsp.window.move({ workspace = 5 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 6, hl.dsp.window.move({ workspace = 6 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 7, hl.dsp.window.move({ workspace = 7 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 8, hl.dsp.window.move({ workspace = 8 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 9, hl.dsp.window.move({ workspace = 9 }))

hl.bind(mainMod .. " + " .. "SHIFT" .. " + " .. 0, hl.dsp.window.move({ workspace = 10 }))

-- will switch to a submap called resize

hl.bind(mainMod .. " + " .. "R", hl.dsp.submap("resize"))

-- will start a submap called "resize"

hl.define_submap("resize", function()
    -- sets repeatable binds for resizing the active window
    hl.bind("l", hl.dsp.window.resize({ x = 10,  y = 0, relative = true }), { repeating = true })
    hl.bind("h", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("k", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("j", hl.dsp.window.resize({ x = 0, y = 10,  relative = true }), { repeating = true })
    -- use reset to go back to the global submap
    hl.bind("escape", hl.dsp.submap("reset"))
    -- will reset the submap, which will return to the global submap
end)


-- Scroll through existing workspaces with mainMod + scroll

hl.bind(mainMod .. " + " .. "mouse_down", hl.dsp.focus({ workspace = "e+1" }))

hl.bind(mainMod .. " + " .. "mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging

hl.bind(mainMod .. " + " .. "mouse:272", hl.dsp.window.drag(), { mouse = true })

hl.bind(mainMod .. " + " .. "mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume

hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })

hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Brightness

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl 10%-"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl 10%+"), { locked = true })

-- Music

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- Brightness

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true })

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("dunst")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("quickshell -p ~/.config/quickshell/bar")
    hl.exec_cmd("vicinae server")
end)
