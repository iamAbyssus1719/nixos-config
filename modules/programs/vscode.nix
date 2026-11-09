
{ pkgs, ... }:

let
  vscodeFixed = pkgs.vscode.overrideAttrs (old: {
    postPatch =
      let
        oldPath =
          "resources/app/node_modules/@vscode/ripgrep/bin/rg";

        newPath =
          "resources/app/node_modules.asar.unpacked/@vscode/ripgrep-universal/bin/linux-x64/rg";

        updated = builtins.replaceStrings
          [ oldPath ]
          [ newPath ]
          old.postPatch;
      in
      builtins.replaceStrings
        [ "rm ''${newPath}" ]
        [ "rm -f ''${newPath}" ]
        updated;
  });

in
{
  environment.systemPackages = [
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
      ];
    })
  ];
}
