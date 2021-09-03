# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Add home manager options
      <home-manager/nixos>
    ];

  boot = {
    # Use newer kernel for wifi support
    kernelPackages = pkgs.linuxPackages_testing;
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;

      # Automatically detect other OS
      grub.useOSProber = true;
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  networking = {
    hostName = "hpbox";
    networkmanager.enable = true;
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };

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
  };
  nixpkgs.config.pulseaudio = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lyn = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "audio" ];
  };

  home-manager.users.lyn = {
    imports = [
      ./home.nix
    ];
  };

  home-manager.users.root = {
    imports = [
      ./home.nix
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # NTFS driver
    ntfs3g

    # Services
    udiskie

    # Manager Per User Configuration
    home-manager

    # Terminal applications
    gnupg
    htop
    wget
    xclip

    # Desktop stuff
    brave
    chromium
    firefox
    libsForQt5.okular
    minecraft
    pinentry-gtk2
    qutebrowser
    sakura
    xscreensaver
    xfce.xfce4-whiskermenu-plugin

    # programming
    git
    docker-compose

    # rust
    cargo
    rustc
    rustup

    # pass
    pass
    qtpass
  ];

  # Docker
  virtualisation.docker.enable = true;

  # IFPS
  services.ipfs.enable = true;

  # Steam
  programs.steam.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Neovim
  programs.neovim.enable = true;

  # Setup x
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce.enable = true;
    };
    displayManager.defaultSession = "xfce";
    libinput.touchpad.tapping = false;
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    keyMode = "vi";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Add Nix Flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };

  # Security
  hardware.cpu.intel.updateMicrocode = true;
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

  system = {
    autoUpgrade = {
      enable = true;
      allowReboot = false;
    };
    #stateVersion = "21.05";
    stateVersion = "unstable";
  };
}
