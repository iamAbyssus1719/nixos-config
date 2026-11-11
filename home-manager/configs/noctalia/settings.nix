
{
  bar = {
    default = {
      capsule_group = [];
      center = [ "clock" "date" ];

      end = [
        "volume"
        "spacer_4"
        "battery"
        "spacer_8"
        "brightness"
        "spacer_2"
        "bluetooth"
        "spacer_5"
        "network"
        "spacer_6"
        "clipboard"
        "spacer_9"
      ];

      font_family = "Inconsolata ExtraBold";

      radius = 0;
      radius_bottom_left = 80;
      radius_bottom_right = 80;
      radius_top_left = 80;
      radius_top_right = 67;

      shadow = false;

      start = [
        "spacer_3"
        "session"
        "spacer_7"
        "button"
        "bar"
      ];

      thickness = 40;
    };
  };

  calendar = {};

  control_center = {
    sidebar = "none";
    sidebar_section = "none";
    width = 600;

    calendar = {
      show_events_card = false;
    };
  };

  desktop_widgets = {
    schema_version = 2;
    widget_order = [];

    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };

    widget = {};
  };

  dock = {
    background_opacity = 0.99999997764825821;
    cross_axis_padding = 0;
    enabled = true;
    icon_size = 32;

    main_axis_padding = 0;

    pinned = [
      "org.gnome.Nautilus"
      "org.mozilla.firefox"
      "com.microsoft.VSCode"
      "org.wezfurlong.wezterm"
      "libreoffice-writer"
    ];

    reserve_space = false;
    shadow = false;
    show_running = false;
    smart_auto_hide = true;
  };

  location = {
    address = "Cacalchén, Yucatán";
  };

  lockscreen_widgets = {
    enabled = false;
    schema_version = 2;
    widget_order = [];

    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };
  };

  plugins = {
    enabled = [];
  };

  shell = {
    avatar_path = "/home/abyssus1719/.config/noctalia/assets/YUKI.jpg";
    font_family = "Inconsolata ExtraBold";
    password_style = "random";
    settings_window_translucent = true;

    launcher = {
      app_grid = true;
      categories = false;
      show_app_actions = true;
    };

    panel = {
      launcher_placement = "attached";
      open_near_click_control_center = true;
      open_near_click_launcher = true;
      open_near_click_session = true;
    };

    screen_corners = {
      enabled = true;
    };
  };

  theme = {
    builtin = "Gruvbox";
    community_palette = "Gruvbox Material Medium";
    shell_mode = "follow";
    source = "community";
  };

  wallpaper = {
    directory = "/home/abyssus1719/.config/noctalia/assets";

    default = {
      path = "/home/abyssus1719/.config/noctalia/assets/HORIZONTAL.jpg";
    };

    last = {
      path = "/home/abyssus1719/.config/noctalia/assets/HORIZONTAL.jpg";
    };

    monitors = {
      "DP-2" = {
        path = "/home/abyssus1719/.config/noctalia/assets/VERTICAL.jpg";
      };

      "HDMI-A-1" = {
        path = "/home/abyssus1719/.config/noctalia/assets/HORIZONTAL.jpg";
      };

      "eDP-1" = {
        path = "/home/abyssus1719/.config/noctalia/assets/HORIZONTAL.jpg";
      };
    };
  };

  widget = {
    active_window = {
      display = "text_only";
    };

    audio_visualizer = {
      bands = 50;
      color_1 = "error";
      color_2 = "error";
      enabled = false;
      show_when_idle = true;
      width = 220;
    };

    bar = {
      type = "eternalself-2328/undershell:bar";
    };

    battery = {
      anchor = true;
      color = "#7A9A6A";
      icon_color = "#7A9A6A";
    };

    bluetooth = {
      color = "#5F8FA3";
      icon_color = "#5F8FA3";
    };

    brightness = {
      color = "#CDA25A";
      icon_color = "#C9A66B";
      show_when_unavailable = true;
    };

    button = {
      type = "michael-retunzew/hyprland-settings:button";
    };

    clipboard = {
      color = "#E07A3F";
      icon_color = "#E07A3F";
      scale = 1.1;
    };

    clock = {
      icon_color = "on_surface_variant";
    };

    "control-center" = {
      color = "#83A598";
      icon_color = "#83A598";
    };

    cpu = {
      color = "#83A598";
      icon_color = "#83A598";
      visualization = "graph";
    };

    date = {
      color = "on_surface_variant";
      icon_color = "on_surface_variant";
    };

    launcher = {
      color = "#B8BB26";
      glyph = "cannabis";
      scale = 1.25;
    };

    network = {
      color = "#9A7A96";
      font_scale = 0.7;
      icon_color = "#9A7A96";
      scale = 1.3;
    };

    session = {
      color = "#7A9A6A";
      glyph = "powersaver";
      icon_color = "#7A9A6A";
      scale = 1.2;
    };

    spacer_2 = {
      type = "spacer";
    };

    spacer_3 = {
      type = "spacer";
    };

    spacer_4 = {
      type = "spacer";
    };

    spacer_5 = {
      type = "spacer";
    };

    spacer_6 = {
      type = "spacer";
    };

    spacer_7 = {
      type = "spacer";
    };

    spacer_8 = {
      type = "spacer";
    };

    spacer_9 = {
      type = "spacer";
    };

    sysmon = {
      color = "#83A598";
      icon_color = "#83A598";
      stat = "disk_used";
      visualization = "graph";
    };

    text_2 = {
      text = "-";
      type = "text";
    };

    text_3 = {
      color = "#FABD2F";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_4 = {
      color = "#FABD2F";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_5 = {
      color = "#689D6A";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_6 = {
      color = "#689D6A";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_7 = {
      color = "#D3869B";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_8 = {
      color = "#D3869B";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_9 = {
      color = "#D65D0E";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_10 = {
      color = "#D65D0E";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_11 = {
      color = "#83A598";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_12 = {
      color = "#83A598";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_13 = {
      color = "#83A598";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_14 = {
      color = "#83A598";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_15 = {
      color = "#B8BB26";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_16 = {
      color = "#B8BB26";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_17 = {
      color = "#FB4934";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_18 = {
      color = "#FB4934";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_19 = {
      color = "on_surface_variant";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_20 = {
      color = "on_surface";
      interactive = false;
      text = "]";
      type = "text";
    };

    text_21 = {
      color = "#83A598";
      interactive = false;
      text = "[";
      type = "text";
    };

    text_22 = {
      color = "#83A598";
      interactive = false;
      text = "]";
      type = "text";
    };

    volume = {
      color = "#C8453A";
      icon_color = "#C8453A";
      scale = 0.95;
    };

    workspaces = {
      active_pill_size = 3.0;
      empty_color = "on_surface_variant";
      pill_scale = 0.7;
      scale = 0.8;
      show_all_outputs = true;
      show_labels = false;
    };
  };
}
