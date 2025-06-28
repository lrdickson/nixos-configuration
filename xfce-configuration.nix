{ pkgs, ... }: {
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [ xfce.xfce4-whiskermenu-plugin ];
}
