{ ... }:

{
  # Enable the Cinnamon Desktop Environment.
  services = {
    xserver = {
      enable = true;
      displayManager.lightdm.enable = true;
      desktopManager.budgie.enable = true;
    };
  };
}
