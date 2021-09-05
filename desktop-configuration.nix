{ config, pkgs, ... }:

{
  # Setup x
  programs.xwayland.enable = true;
  services.xserver = {
    enable = true;
    desktopManager = {
      #cinnamon.enable = true;
      gnome.enable = true;
      #plasma5.enable = true;
      xfce.enable = true;
      xterm.enable = false;
    };
    displayManager.defaultSession = "xfce";
    displayManager.gdm.wayland = true;
    libinput.touchpad.tapping = false;
  };
  hardware.opengl.enable = true;

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  programs.system-config-printer.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  nixpkgs.config.pulseaudio = true;
}
