{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    neovim
    gh
    nodejs
  ];
}
