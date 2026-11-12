
{ ... }:

{
  xdg.configFile."Code/User/settings.json".text =
    builtins.toJSON {
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "workbench.productIconTheme" = "fluent-icons";
      "workbench.iconTheme" = "material-icon-theme";

      "editor.fontSize" = 17;
      "editor.fontFamily" = "'Inconsolata ExtraBold', monospace";

      "workbench.sideBar.location" = "right";
      "security.workspace.trust.untrustedFiles" = "open";
      "explorer.compactFolders" = false;

      "github.copilot.enable" = {
        "*" = false;
        "plaintext" = false;
        "markdown" = false;
        "scminput" = false;
      };

      "tailwindCSS.includeLanguages" = {
        "vue" = "html";
      };
    };
}
