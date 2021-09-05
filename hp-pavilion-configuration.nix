{ config, pkgs, ... }:

{
  boot = {
    # Use newer kernel for wifi support
    # kernelPackages = pkgs.linuxPackages_testing;
    # The rtw88_8821ce module kind of stinks
    blacklistedKernelModules = [
      "rtw88_8821ce"
    ];
    extraModulePackages = [
      pkgs.linuxPackages.rtl8821ce
    ];
  };
}
