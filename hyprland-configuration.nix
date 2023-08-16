{ config, pkgs, ... }:

let
  xdph = pkgs.xdg-desktop-portal-hyprland;
  xdph-cfg = {};
  iniSettingsFormat = pkgs.formats.ini { };
  xdphConfigFile = iniSettingsFormat.generate "xdg-desktop-portal-wlr.ini" xdph-cfg;
  # waybarHyperland = builtins.getFlake "github:hyprwm/hyprland";
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
  myeww = pkgs.callPackage ./eww.nix {};
in
{
  # hyprland
  programs.hyprland = {
    enable = true;

    xwayland = {
      enable = true;
      hidpi = false;
    };

    nvidiaPatches = false;
  };
  services.xserver.displayManager.sddm.enable = true;
  #xdg.portal.wlr.enable = true;

  systemd.user.services.xdg-desktop-portal-wlr.serviceConfig.ExecStart = [
    # Empty ExecStart value to override the field
    ""
    "${xdph}/libexec/xdg-desktop-portal-wlr --config=${xdphConfigFile}"
  ];

  # nixpkgs.overlays = [waybarHyperland.overlays.default];
  # xbacklight doesn't work with wayland
  programs.light.enable = true;
  environment.systemPackages = with pkgs; [
    # hyprland
    foot
    font-awesome
    mako # wayland notification daemon
    swayidle
    swaylock
    # waybar-hyprland
    wofi # wayland app launcher
    libsForQt5.polkit-kde-agent # Authentication agent

    # Packages for eww
    eww-wayland
    python3
    jq
    socat
  ];

  # Add Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
