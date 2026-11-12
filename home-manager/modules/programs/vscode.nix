
{ pkgs, ... }:

let
  vscodeFixed = pkgs.vscode.overrideAttrs (old: {
    postPatch = builtins.replaceStrings
      [
        "rm resources/app/node_modules/@vscode/ripgrep/bin/rg"
      ]
      [
        ''
          mkdir -p resources/app/node_modules/@vscode/ripgrep/bin
          rm -f resources/app/node_modules/@vscode/ripgrep/bin/rg
        ''
      ]
      (old.postPatch or "");
  });

in
{
  home.packages = [
    (pkgs.vscode-with-extensions.override {
      vscode = vscodeFixed;

      vscodeExtensions = with pkgs.vscode-extensions; [
        jdinhlife.gruvbox
        esbenp.prettier-vscode
        formulahendry.auto-rename-tag
        usernamehw.errorlens
        miguelsolorio.fluent-icons
        ms-python.python
        pkief.material-icon-theme
        vue.volar
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
      ];
    })
  ];
}
