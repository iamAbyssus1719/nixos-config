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
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      test-build = "nix --extra-experimental-features 'nix-command flakes' flake check /etc/nixos";
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
