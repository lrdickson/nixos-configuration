{ ... }:

{
  # Enable the Cinnamon Desktop Environment.
  services = {
    # displayManager.sddm.enable = true;
    xserver.displayManager.lightdm.enable = true;
    xserver.desktopManager.cinnamon.enable = true;
  };
}
