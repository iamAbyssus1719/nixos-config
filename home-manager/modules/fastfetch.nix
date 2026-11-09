{ pkgs, ... }: {
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding = {
          right = 2; 
        };
      };
      display = {
        size = {
          binaryPrefix = "si";
        };
        color = "blue";
        separator = "  ";
      };
      modules = [
	"title"
      {
    	type = "custom";
    	format = "──────────────────────────────────";
      }
      {
        type = "OS";
        key = " ";
      }
      {
        type = "kernel";
        key = " ";
      }
      {
        type = "packages";
        key = " ";
      }
      {
        type = "uptime";
        key = " ";
      }
      {
        type = "custom";
        format = "──────────────────────────────────";
      }
      {
	type = "custom";
	format = "{##928374}▄▄ {##fb4934}▄▄ {##b8bb26}▄▄ {##fabd2f}▄▄ {##83a598}▄▄ {##d3869b}▄▄ {##8ec07c}▄▄ {##ebdbb2}▄▄{#}";
      }
      ];
    };
  };
}
