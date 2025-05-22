{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      mate.enable = true;
    };
  };

  environment.systemPackages = with pkgs; with mate; [
    ulauncher
    rofi
    # (pkgs.callPackage ./mate-menu.nix {
    #   mate-menus = mate.mate-menus;
    #   mate-panel = mate.mate-panel;
    # })
  ];
}
