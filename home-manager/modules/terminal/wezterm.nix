
{ ... }:

{
  home.file.".config/wezterm/wezterm.lua".text = ''
    local wezterm = require("wezterm")

    local gruvbox_colors = {
        background = "#1d2021",
        foreground = "#ebdbb2",
        cursor_bg = "#928374",
        cursor_fg = "#1d2021",
        cursor_border = "#928374",
        selection_fg = "#1d2021",
        selection_bg = "#ebdbb2",
        scrollbar_thumb = "#ebdbb2",
        split = "#282828",

        ansi = {
            "#282828", "#cc241d", "#98971a", "#d79921",
            "#458588", "#b16286", "#689d6a", "#a89984",
        },

        brights = {
            "#928374", "#fb4934", "#b8bb26", "#fabd2f",
            "#83a598", "#d3869b", "#8ec07c", "#ebdbb2",
        },
    }

    return {
        enable_wayland = true,

        color_schemes = {
            ["Gruvbox"] = gruvbox_colors,
        },
        color_scheme = "Gruvbox",

        font = wezterm.font("Inconsolata", { weight = "ExtraBold" }),
        font_size = 17,

        default_cursor_style = "BlinkingBar",

        window_close_confirmation = "NeverPrompt",
        hide_tab_bar_if_only_one_tab = true,

        window_padding = {
            top = "1cell",
            right = "3cell",
            bottom = "1cell",
            left = "3cell",
        },

        inactive_pane_hsb = {
            saturation = 0.9,
            brightness = 0.8,
        },

        window_background_opacity = 1.0,
        text_background_opacity = 1.0,
    }
  '';
}
