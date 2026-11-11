--  __    __  ____    ____ .______   .______       __          ___      .__   __.  _______
-- |  |  |  | \   \  /   / |   _  \  |   _  \     |  |        /   \     |  \ |  | |       \
-- |  |__|  |  \   \/   /  |  |_)  | |  |_)  |    |  |       /  ^  \    |   \|  | |  .--.  |
-- |   __   |   \_    _/   |   ___/  |      /     |  |      /  /_\  \   |  . `  | |  |  |  |
-- |  |  |  |     |  |     |  |      |  |\  \----.|  `----./  _____  \  |  |\   | |  '--'  |
-- |__|  |__|     |__|     | _|      | _| `._____||_______/__/     \__\ |__| \__| |_______/

-- Variables
local mainMod = "SUPER"

------------------------------------------------------------
-- Monitors
------------------------------------------------------------
local offset = 271

hl.monitor({ output = "DP-2",     mode = "1920x1080@144", position = "0x0",                      scale = 1, transform = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@144", position = "1080x" .. offset,          scale = 1 })
hl.monitor({ output = "eDP-1",    mode = "1920x1080@60",  position = "3000x" .. (offset + 100),  scale = 1 })

------------------------------------------------------------
-- Environment Variables
------------------------------------------------------------
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
hl.env("_JAVA_AWT_WM_NONEREPARENTING", "1")
hl.env("GDK_BACKEND", "wayland,x11,*")

------------------------------------------------------------
-- Autostarts (antes exec-once)
------------------------------------------------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("/home/abyssus1719/.config/hypr/scripts/opacity.sh")
    hl.exec_cmd("swww-daemon")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("~/.config/hypr/portals.sh")
    hl.exec_cmd("sleep 4 && quickshell -p /home/abyssus1719/.config/quickshell/Reloj/shell.qml")
    hl.exec_cmd("quickshell -c Menu")
    -- hl.exec_cmd("sleep 4 && quickshell -p /home/abyssus1719/.config/quickshell/dock/shell.qml")

end)

------------------------------------------------------------
-- Look and Feel
------------------------------------------------------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 0,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,

        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,

        active_opacity = 1,
        inactive_opacity = 1,

        
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size = 5,
            passes = 1,
            new_optimizations = true,
            noise = 0,
            brightness = 1, 
        },

    },

    animations = {
        enabled = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },

    -- dwindle = {
    --     preserve_split = true,
    -- },
})

------------------------------------------------------------
-- Animations
------------------------------------------------------------

-- Curves
hl.curve("expressiveFastSpatial",    { type = "bezier", points = { { 0.42, 1.67 }, { 0.21, 0.90 } } })
hl.curve("expressiveSlowSpatial",    { type = "bezier", points = { { 0.39, 1.29 }, { 0.35, 0.98 } } })
hl.curve("expressiveDefaultSpatial", { type = "bezier", points = { { 0.38, 1.21 }, { 0.22, 1.00 } } })
hl.curve("emphasizedDecel",          { type = "bezier", points = { { 0.05, 0.7 },  { 0.1, 1 } } })
hl.curve("emphasizedAccel",          { type = "bezier", points = { { 0.3, 0 },     { 0.8, 0.15 } } })
hl.curve("standardDecel",            { type = "bezier", points = { { 0, 0 },       { 0, 1 } } })
hl.curve("menu_decel",               { type = "bezier", points = { { 0.1, 1 },     { 0, 1 } } })
hl.curve("menu_accel",               { type = "bezier", points = { { 0.52, 0.03 }, { 0.72, 0.08 } } })
hl.curve("stall",                    { type = "bezier", points = { { 1, -0.1 },    { 0.7, 0.85 } } })

-- windows
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3,  bezier = "emphasizedDecel", style = "popin 80%" })
hl.animation({ leaf = "fadeIn",      enabled = true, speed = 3,  bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2,  bezier = "emphasizedDecel", style = "popin 90%" })
hl.animation({ leaf = "fadeOut",     enabled = true, speed = 2,  bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3,  bezier = "emphasizedDecel", style = "slide" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "emphasizedDecel" })

hl.animation({ leaf = "layersIn",  enabled = true, speed = 4, bezier = "default", style = "popin 90%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, bezier = "default", style = "popin 90%" })

-- fade
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.7, bezier = "stall" })

-- workspaces
hl.animation({ leaf = "workspaces", enabled = true, speed = 7, bezier = "menu_decel", style = "slide" })

-- specialWorkspace
hl.animation({ leaf = "specialWorkspaceIn",  enabled = true, speed = 2.8, bezier = "emphasizedDecel", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, bezier = "emphasizedAccel", style = "slidevert" })

-- zoom
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 3, bezier = "standardDecel" })

------------------------------------------------------------
-- Input
------------------------------------------------------------
hl.config({
    input = {
        kb_layout = "us,es",
        kb_options = "grp:win_space_toggle",

        follow_mouse = 1,

        sensitivity = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})


hl.device({
    name = "epic-mouse-v1",
    sensitivity = 0,
})

------------------------------------------------------------
-- Keybinds
------------------------------------------------------------
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("wezterm"))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())
hl.bind(mainMod .. " + M",      hl.dsp.exit())
hl.bind(mainMod .. " + E",      hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + V",      hl.dsp.exec_cmd("bash /home/abyssus1719/.config/hypr/scripts/Flotantes.sh"))
hl.bind(mainMod .. " + R",      hl.dsp.exec_cmd("quickshell -c Menu ipc call launcher toggle"))
hl.bind(mainMod .. " + O",      hl.dsp.exec_cmd("bash /home/abyssus1719/.config/hypr/scripts/Opacidad.sh"))
hl.bind(mainMod .. " + L",      hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + F",      hl.dsp.exec_cmd("firefox"))

hl.bind(mainMod .. " + W",      hl.dsp.exec_cmd("/home/abyssus1719/.config/hypr/scripts/captura.sh menu"))

-- Mover el foco
hl.bind(mainMod .. " + left",   hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",  hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",   hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-10 (la tecla 0 es el workspace 10)
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Workspace especial
hl.bind(mainMod .. " + C",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.window.move({ workspace = "special:magic" }))

-- Cambiar de workspace con la rueda del mouse
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Mover / redimensionar ventanas con el mouse (antes bindm)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volumen y brillo (antes bindel)
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),  { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),       { repeating = true, locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),      { repeating = true, locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),    { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                   { repeating = true, locked = true })

-- Controles multimedia (antes bindl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

------------------------------------------------------------
-- Window rules
------------------------------------------------------------
-- hl.layer_rule({ match = { namespace = ".*" }, blur = true })
-- hl.layer_rule({ match = { namespace = ".*" }, ignore_alpha = 0.3 })

hl.window_rule({
    name  = "float-satty",
    match = { class = "^(com.gabm.satty)$" },
    float = true,
})

hl.window_rule({
    name  = "float-toplevel",
    match = { class = "^(Toplevel)$" },
    float = true,
})

------------------------------------------------------------
-- XWayland
------------------------------------------------------------
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
