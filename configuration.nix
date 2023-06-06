# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, fetchFromGitHub, ... }:

let
options = import ./defaultOptions.nix // import ./options.nix;
hardwareConfiguration =
  if options.hardware then [ ./hardware-configuration.nix ] else [];
desktopConfiguration =
  if options.desktop then [ ./desktop-configuration.nix ] else [];
hpPavilionConfiguration =
  if options.hpPavilion then [ ./hp-pavilion-configuration.nix ] else [];
hyprlandConfiguration =
  if options.hpPavilion then [ ./hyprland-configuration.nix ] else [];
nnn-git = pkgs.fetchFromGitHub {
  owner = "jarun";
  repo = "nnn";
  rev = "f6856f61f74977a7929a601a4fc28168d2cc043c";
  sha256 = "1zd6vnbb08fslyk7grbkp1lg31jci9ryway02ms4bw54xvaqf4d3";
};
nicoleConfiguration =
  if options.nicole then [ ./nicole-configuration.nix ] else [];
nicoleFish = if options.nicole then ''
  function rcon-cli
    sudo docker exec -i minecraft rcon-cli
  end
  '' else "";
cloudsdaleConfiguration =
  if options.cloudsdale then [ ./cloudsdale-configuration.nix ] else [];
piConfiguration =
  if options.pi then [ ./pi-configuration.nix ] else [];
isIntel = ! options.pi;
in
{
  imports =
    [
    ] ++
    hardwareConfiguration ++
    cloudsdaleConfiguration ++
    hpPavilionConfiguration ++
    hyprlandConfiguration ++
    desktopConfiguration ++
    nicoleConfiguration ++
    piConfiguration;

  boot = {
    loader = {
      # Use the systemd-boot EFI boot loader.
      systemd-boot.enable = !options.pi && !options.luks;
      efi.canTouchEfiVariables = true;
    };
  };

  boot.loader.grub = if options.luks then {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;

    # Automatically detect other OS
    useOSProber = options.multiboot;
  } else {
    # Automatically detect other OS
    useOSProber = options.multiboot;
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

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lyn = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "scanner" "lp" # Needed to allow scanning
      "video"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #btrfs-progs
    docker-compose
    efibootmgr
    emacs
    fzf
    git
    htop
    #ncurses # for moe text editor
    neovim
    nnn
    psmisc # killall and others
    smartmontools # hard drive health monitoring
    tcpdump
    #vim
    wget
  ];

  # bashrc
  programs.bash = {
    interactiveShellInit = ''
        # Set neovim as the default editor
        export EDITOR=nvim

        # Fix terminal colors
        export TERM=xterm-256color
      '' + builtins.readFile "${nnn-git}/misc/quitcd/quitcd.bash_zsh";
    };

  # Fish
  users.defaultUserShell = pkgs.fish;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Fix terminal colors
      set -x TERM xterm-256color

      # Turn on vi keybindings
      fish_vi_key_bindings
    '' + nicoleFish;
    shellInit = ''
      # Set the default editor
      export EDITOR=nvim

      # Source fish_init_extra if it exists
      if test -f "$HOME/.fish_init_extra"
        . "$HOME/.fish_init_extra"
      end
      if test -f "$HOME/.fishrc"
        . "$HOME/.fishrc"
      end
    '' + builtins.readFile "${nnn-git}/misc/quitcd/quitcd.fish";
  };

  # Docker
  virtualisation.docker.enable = true;

  # IFPS
  #services.ipfs.enable = true;

  # Tmux configuration
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    extraConfig = ''
      set -g default-command ${pkgs.fish}/bin/fish
      set -g default-shell ${pkgs.fish}/bin/fish
      '';
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

  # Security
  hardware.cpu.intel.updateMicrocode = isIntel;
  #services.clamav = {
    #daemon.enable = true;
    #updater.enable = true;
  #};

  system = {
    #autoUpgrade = {
      #enable = true;
      #allowReboot = false;
    #};
    stateVersion = "22.11";
    #stateVersion = "unstable";
  };
}
