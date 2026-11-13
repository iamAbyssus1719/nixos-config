{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (google-fonts.override {
      fonts = [
        "ShipporiMincho"
        "ShipporiMinchoB1" # Opcional: variante con esquinas redondeadas
      ];
    })
  ];
}
