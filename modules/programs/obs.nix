{ config, pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;

    # Opcional: Agrega los plugins que necesites directamente
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs                  # Captura de pantalla en compositores Wayland (wlroots)
      obs-backgroundremoval   # Eliminación de fondo por IA
      obs-pipewire-audio-capture # Captura de audio por aplicación en PipeWire
    ];
  };
}
