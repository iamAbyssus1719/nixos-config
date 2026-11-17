
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
      margin_ends = 300;

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
        "launcher"
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
      "firefox"
      "code"
      "org.wezfurlong.wezterm"
      "com.obsproject.Studio"
      "discord"
      "osu!"
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
    enabled = true;
    schema_version = 2;

    widget_order = [
      "lockscreen-widget-0000000000000008"
      "lockscreen-widget-0000000000000001"
      "lockscreen-login-box@DP-2"
      "lockscreen-login-box@HDMI-A-1"
      "lockscreen-login-box@eDP-1"
      "lockscreen-widget-0000000000000002"
      "lockscreen-widget-0000000000000003"
      "lockscreen-widget-0000000000000004"
      "lockscreen-widget-0000000000000005"
      "lockscreen-widget-0000000000000006"
      "lockscreen-widget-0000000000000007"
      "lockscreen-widget-0000000000000009"
      "lockscreen-widget-000000000000000a"
      "lockscreen-widget-000000000000000b"
      "lockscreen-widget-000000000000000c"
      "lockscreen-widget-000000000000000d"
      "lockscreen-widget-000000000000000e"
      "lockscreen-widget-000000000000000f"
      "lockscreen-widget-0000000000000010"
      "lockscreen-widget-0000000000000011"
      "lockscreen-widget-0000000000000012"
      "lockscreen-widget-0000000000000013"
      "lockscreen-widget-0000000000000014"
      "lockscreen-widget-0000000000000015"
      "lockscreen-widget-0000000000000016"
      "lockscreen-widget-0000000000000017"
      "lockscreen-widget-0000000000000018"
    ];

    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };

    widget = {
      "lockscreen-login-box@DP-2" = {
        box_height = 196.0;
        box_width = 810.0;
        cx = 519.0;
        cy = 1330.0;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = 0.0;
        type = "login_box";

        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12.0;
          center_password_text = false;
          input_opacity = 1.0;
          input_radius = 6.0;
          layout = "regular";
          show_caps_lock = true;
          show_keyboard_layout = true;
          show_login_button = true;
          show_media = true;
          show_session_buttons = true;
          show_unlock_hint = true;
          show_weather = true;
        };
      };

      "lockscreen-login-box@HDMI-A-1" = {
        box_height = 196.0;
        box_width = 810.0;
        cx = 960.0;
        cy = 906.0;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "login_box";

        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12.0;
          center_password_text = false;
          input_opacity = 1.0;
          input_radius = 6.0;
          layout = "regular";
          show_caps_lock = true;
          show_keyboard_layout = true;
          show_login_button = true;
          show_media = true;
          show_session_buttons = true;
          show_unlock_hint = true;
          show_weather = true;
        };
      };

      "lockscreen-login-box@eDP-1" = {
        box_height = 196.0;
        box_width = 810.0;
        cx = 960.0;
        cy = 898.0;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "login_box";

        settings = {
          background_color = "surface_variant";
          background_opacity = 0.88;
          background_radius = 12.0;
          center_password_text = false;
          input_opacity = 1.0;
          input_radius = 6.0;
          layout = "regular";
          show_caps_lock = true;
          show_keyboard_layout = true;
          show_login_button = true;
          show_media = true;
          show_session_buttons = true;
          show_unlock_hint = true;
          show_weather = true;
        };
      };

      "lockscreen-widget-0000000000000001" = {
        box_height = 384.0;
        box_width = 624.0;
        cx = 960.0;
        cy = 492.0;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 1.0;
          background_padding = 13;
          background_radius = 32;
          center_text = false;
          clock_style = "digital";
          font_family = "Inconsolata ExtraBold";
          format = "";
          shadow = true;
        };
      };

      "lockscreen-widget-0000000000000002" = {
        box_height = 256.0;
        box_width = 464.0;
        cx = 960.0;
        cy = 422.0;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-0000000000000003" = {
        box_height = 144.0;
        box_width = 224.0;
        cx = 944.0;
        cy = 516.0;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
          color = "on_surface_variant";
          format = "{:%a, %b %d}";
        };
      };

      "lockscreen-widget-0000000000000004" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 764.0;
        cy = 596.0;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "weather";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-0000000000000005" = {
        box_height = 112.0;
        box_width = 224.0;
        cx = 1136.0;
        cy = 596.0;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "volume";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-0000000000000006" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 916.0;
        cy = 596.0;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "sysmon";

        settings = {
          background_opacity = 0.0;
          stat = "cpu_usage";
          stat2 = "cpu_temp";
        };
      };

      "lockscreen-widget-0000000000000007" = {
        box_height = 144.0;
        box_width = 576.0;
        cx = 960.0;
        cy = 188.0;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
          color = "on_hover";
          format = "L o c k e d";
        };
      };

      "lockscreen-widget-0000000000000008" = {
        box_height = 384.0;
        box_width = 624.0;
        cx = 960.0;
        cy = 476.0;
        flip_x = true;
        output = "HDMI-A-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = -0.2617993950843811;
        type = "clock";

        settings = {
          background_opacity = 0.86;
          background_padding = 13;
          background_radius = 32;
          center_text = false;
          clock_style = "digital";
          font_family = "Inconsolata ExtraBold";
          format = "";
          shadow = true;
        };
      };

      "lockscreen-widget-0000000000000009" = {
        box_height = 384.0;
        box_width = 624.0;
        cx = 524.0;
        cy = 920.0;
        flip_x = true;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = -0.2617993950843811;
        type = "clock";

        settings = {
          background_opacity = 0.86;
          background_padding = 13;
          background_radius = 32;
          center_text = false;
          clock_style = "digital";
          font_family = "Inconsolata ExtraBold";
          format = "";
          shadow = true;
        };
      };

      "lockscreen-widget-000000000000000a" = {
        box_height = 384.0;
        box_width = 624.0;
        cx = 524.0;
        cy = 936.0;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 1.0;
          background_padding = 13;
          background_radius = 32;
          center_text = false;
          clock_style = "digital";
          font_family = "Inconsolata ExtraBold";
          format = "";
          shadow = true;
        };
      };

      "lockscreen-widget-000000000000000b" = {
        box_height = 256.0;
        box_width = 464.0;
        cx = 524.0;
        cy = 866.0;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-000000000000000c" = {
        box_height = 144.0;
        box_width = 224.0;
        cx = 508.0;
        cy = 960.0;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
          color = "on_surface_variant";
          format = "{:%a, %b %d}";
        };
      };

      "lockscreen-widget-000000000000000d" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 328.0;
        cy = 1040.0;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = 0.0;
        type = "weather";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-000000000000000e" = {
        box_height = 112.0;
        box_width = 224.0;
        cx = 700.0;
        cy = 1040.0;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = 0.0;
        type = "volume";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-000000000000000f" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 480.0;
        cy = 1040.0;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = 0.0;
        type = "sysmon";

        settings = {
          background_opacity = 0.0;
          stat = "cpu_usage";
          stat2 = "cpu_temp";
        };
      };

      "lockscreen-widget-0000000000000010" = {
        box_height = 384.0;
        box_width = 624.0;
        cx = 944.0;
        cy = 516.0;
        flip_x = true;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = -0.2617993950843811;
        type = "clock";

        settings = {
          background_opacity = 0.86;
          background_padding = 13;
          background_radius = 32;
          center_text = false;
          clock_style = "digital";
          font_family = "Inconsolata ExtraBold";
          format = "";
          shadow = true;
        };
      };

      "lockscreen-widget-0000000000000011" = {
        box_height = 384.0;
        box_width = 624.0;
        cx = 944.0;
        cy = 532.0;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 1.0;
          background_padding = 13;
          background_radius = 32;
          center_text = false;
          clock_style = "digital";
          font_family = "Inconsolata ExtraBold";
          format = "";
          shadow = true;
        };
      };

      "lockscreen-widget-0000000000000012" = {
        box_height = 256.0;
        box_width = 464.0;
        cx = 944.0;
        cy = 462.0;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-0000000000000013" = {
        box_height = 144.0;
        box_width = 224.0;
        cx = 928.0;
        cy = 556.0;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
          color = "on_surface_variant";
          format = "{:%a, %b %d}";
        };
      };

      "lockscreen-widget-0000000000000014" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 748.0;
        cy = 636.0;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "weather";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-0000000000000015" = {
        box_height = 112.0;
        box_width = 224.0;
        cx = 1120.0;
        cy = 636.0;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "volume";

        settings = {
          background_opacity = 0.0;
        };
      };

      "lockscreen-widget-0000000000000016" = {
        box_height = 0.0;
        box_width = 0.0;
        cx = 900.0;
        cy = 636.0;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "sysmon";

        settings = {
          background_opacity = 0.0;
          stat = "cpu_usage";
          stat2 = "cpu_temp";
        };
      };

      "lockscreen-widget-0000000000000017" = {
        box_height = 144.0;
        box_width = 576.0;
        cx = 944.0;
        cy = 212.0;
        output = "eDP-1";
        placement_height = 1080.0;
        placement_width = 1920.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
          color = "on_hover";
          format = "L o c k e d";
        };
      };

      "lockscreen-widget-0000000000000018" = {
        box_height = 144.0;
        box_width = 576.0;
        cx = 540.0;
        cy = 616.0;
        output = "DP-2";
        placement_height = 1920.0;
        placement_width = 1080.0;
        rotation = 0.0;
        type = "clock";

        settings = {
          background_opacity = 0.0;
          color = "on_hover";
          format = "L o c k e d";
        };
      };
    };
  };

  plugins = {
    enabled = [
      "frai3mega/battery-graph"
      "yocraft/desktop-launcher"
    ];
  };

  shell = {
    avatar_path = "/home/abyssus1719/.config/noctalia/assets/YUKI.jpg";
    font_family = "Inconsolata ExtraBold";
    password_style = "random";
    settings_show_advanced = false;
    settings_window_translucent = true;

    launcher = {
      app_grid = true;
      categories = false;
      show_app_actions = true;
    };

    panel = {
      launcher_placement = "floating";
      launcher_position = "bottom_center";
      open_near_click_control_center = true;
      open_near_click_launcher = false;
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
      path = "/home/abyssus1719/.config/noctalia/assets/VERTICAL.jpg";
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
