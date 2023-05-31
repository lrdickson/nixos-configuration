{ config, pkgs, ... }:

let
  xdph = pkgs.xdg-desktop-portal-hyprland;
  xdph-cfg = {};
  iniSettingsFormat = pkgs.formats.ini { };
  xdphConfigFile = iniSettingsFormat.generate "xdg-desktop-portal-wlr.ini" xdph-cfg;
  waybarHyperland = builtins.getFlake "github:hyprwm/hyprland";
  #waybar-hyprland = pkgs.waybar.overrideAttrs (finalAttrs: previousAttrs: {
    #version = "nightly";
    #src = pkgs.fetchFromGitHub {
      #owner = "r-clifford";
      #repo = "Waybar-Hyprland";
      #rev = "caa06ab";
      #hash = "sha256-rDK0HPjyfd67qvdTW8EwiO0v47ElFZHUNlR+9weAKak=";
    #};
    #preBuild = ''
      #sed -i -e 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' ../src/modules/wlr/workspace_manager.cpp
    #'';
    #mesonFlags = [
      #"-Dexperimental=true"
    #];
  #});
in
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lyn = {
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio" ];
  };

  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking.networkmanager.enable = true;

  # hyprland
  programs.hyprland = {
    enable = true;

    xwayland = {
      enable = true;
      hidpi = false;
    };

    nvidiaPatches = false;
  };
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  #xdg.portal.wlr.enable = true;
  security.polkit.enable = true;
  security.pam.services.swaylock = {};
  hardware.opengl.enable = true;
  hardware.bluetooth.enable = true;
  #extraPackages = [ pkgs.mesa.drivers ];

  systemd.user.services.xdg-desktop-portal-wlr.serviceConfig.ExecStart = [
    # Empty ExecStart value to override the field
    ""
    "${xdph}/libexec/xdg-desktop-portal-wlr --config=${xdphConfigFile}"
  ];

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  programs.system-config-printer.enable = true;

  # Enable scanning
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplipWithPlugin ];
  };
  services.avahi.enable = true;
  services.avahi.nssmdns = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };
  nixpkgs.config.pulseaudio = true;

  # Gnome settings daemon
  #services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];

  nixpkgs.overlays = [waybarHyperland.overlays.default];
  # xbacklight doesn't work with wayland
  programs.light.enable = true;
  environment.systemPackages = with pkgs; [
    # NTFS driver
    ntfs3g

    # Terminal applications
    xclip
    acpi # battery monitoring cli

    # xfce
    #xfce.xfce4-whiskermenu-plugin

    # hyprland
    foot
    font-awesome
    mako # wayland notification daemon
    swayidle
    swaylock
    waybar-hyprland
    wofi # wayland app launcher
    libsForQt5.polkit-kde-agent # Authentication agent

    # Desktop stuff
    #libsForQt5.filelight
    #libsForQt5.okular
    pinentry-gtk2
    xfce.thunar

    glxinfo # GL testing
  ];

  fonts.fonts = with pkgs; [
    cantarell-fonts
    noto-fonts
    nerdfonts

    font-awesome
  ];

  # Add Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
