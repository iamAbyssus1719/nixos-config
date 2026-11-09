
{ ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;

      format = "$os $directory $container$git_branch$git_status$python$nodejs$lua$rust$java$c$golang$status\n$character";

      continuation_prompt = "∙  ┆ ";

      line_break.disabled = false;

      status = {
        symbol = "✗";
        not_found_symbol = "󰍉 Not Found";
        not_executable_symbol = " Can't Execute E";
        sigint_symbol = "󰂭 ";
        signal_symbol = "󱑽 ";
        success_symbol = "";
        format = "[$symbol](fg:#fb4934)";
        map_symbol = true;
        disabled = false;
      };

      cmd_duration = {
        min_time = 1000;
        format = "[$duration ](fg:#fabd2f)";
      };

      container = {
        symbol = " 󰏖";
        format = "[$symbol ](fg:#fabd2f dimmed)";
      };

      directory = {
        format = "[](fg:#3c3836)[$path](bg:#3c3836 fg:#ebdbb2)[](fg:#3c3836)";
        truncation_length = 6;
        truncation_symbol = "~/󰇘/";
      };

      git_branch = {
        symbol = "󰊢 ";
        style = "";
        format = "[ $symbol $branch](fg:#fe8019)(:$remote_branch)";
      };

      os = {
        disabled = false;
        format = "[$symbol](fg:#83a598)";

        symbols = {
          Arch = "";
          Debian = "";
          EndeavourOS = "";
          Fedora = "󰣛  ";
          NixOS = " ";
          openSUSE = "";
          SUSE = "";
          Ubuntu = "";
        };
      };

      character = {
        success_symbol = "[](bold #d3869b) ";
        error_symbol = "[](bold #fb4934) ";
      };

      python = {
        symbol = "";
        format = "[$symbol ](fg:#fabd2f)";
      };

      nodejs = {
        symbol = "";
        format = "[$symbol ](fg:#b8bb26)";
      };

      lua = {
        symbol = "󰢱";
        format = "[$symbol ](fg:#458588)";
      };

      rust = {
        symbol = "";
        format = "[$symbol ](fg:#fb4934)";
      };

      java = {
        symbol = "";
        format = "[$symbol ](fg:#fb4934)";
      };

      c = {
        symbol = "";
        format = "[$symbol ](fg:#458588)";
      };

      golang = {
        symbol = "";
        format = "[$symbol ](fg:#458588)";
      };
    };
  };
}
