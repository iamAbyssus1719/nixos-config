{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lah";
      update = "sudo nixos-rebuild switch";
    };

    initContent = ''
      fastfetch
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "colored-man-pages"
      ];

      theme = "robbyrussell";
    };
  };
}
