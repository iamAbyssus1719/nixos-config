
{ ... }:

{
  xdg.configFile."Code/User/settings.json".text =
    builtins.toJSON {
      # Tema e iconos
      "workbench.colorTheme" = "Gruvbox Dark Hard";
      "workbench.productIconTheme" = "fluent-icons";
      "workbench.iconTheme" = "material-icon-theme";

      # Editor
      "editor.fontSize" = 17;
      "editor.fontFamily" = "'Inconsolata ExtraBold', monospace";
      "editor.quickSuggestions" = {
        "strings" = "on";
      };

      # Interfaz
      "workbench.sideBar.location" = "right";
      "security.workspace.trust.untrustedFiles" = "open";
      "explorer.compactFolders" = false;

      # Copilot
      "github.copilot.enable" = {
        "*" = false;
        "plaintext" = false;
        "markdown" = false;
        "scminput" = false;
      };

      # Emmet: soporte para Vue y HTML
      "emmet.includeLanguages" = {
        "vue" = "html";
        "vue-html" = "html";
      };

      "emmet.triggerExpansionOnTab" = true;

      # Tailwind CSS IntelliSense
      "tailwindCSS.includeLanguages" = {
        "vue" = "html";
      };

      "tailwindCSS.experimental.configFile" = {
        "resources/css/app.css" = [
          "**/*.vue"
          "**/*.blade.php"
        ];
      };
    };
}
