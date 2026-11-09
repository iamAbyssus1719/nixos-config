{ pkgs, ... }:

{
  services.pulseaudio.enable = false;

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = with pkgs; [
    pulseaudio
    alsa-utils
  ];

  systemd.user.services.es8316-speaker-fix = {
    description = "Enable ES8316 speaker mixer paths";
    wantedBy = [ "default.target" ];
    after = [ "wireplumber.service" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "es8316-speaker-fix" ''
        ${pkgs.alsa-utils}/bin/amixer -c acp3xes83xx sset 'Left Headphone Mixer Left DAC' on
        ${pkgs.alsa-utils}/bin/amixer -c acp3xes83xx sset 'Right Headphone Mixer Right DAC' on
        ${pkgs.alsa-utils}/bin/amixer -c acp3xes83xx sset Speaker on
      '';
    };
  };
}
