{ pkgs, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") { };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

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
      "audio"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    docker-compose
    efibootmgr
    git
    htop
    neovim
    nushell
    psmisc # killall and others
    smartmontools # hard drive health monitoring
    tcpdump
    tldr
    wget
    zoxide

    unstable.helix
    unstable.yazi
    unstable.zellij

    ltex-ls # latex and markdown lsp, with spell checking
    marksman # markdown lsp
    nil # nix language server
    nixd # official nix language server
    taplo # toml lsp
    typos-lsp # spell-checker language server
  ];

  # Fish
  # users.defaultUserShell = pkgs.elvish;
  users.defaultUserShell = pkgs.fish;
  # users.defaultUserShell = pkgs.nushell;
  programs.fish = {
    enable = true;
  };

  # Docker
  virtualisation.docker.enable = true;

  # IFPS
  #services.ipfs.enable = true;

  # Tmux configuration
      # set -g default-command ${pkgs.fish}/bin/fish
      # set -g default-shell ${pkgs.fish}/bin/fish
      # set -g default-command ${pkgs.elvish}/bin/elvish
      # set -g default-shell ${pkgs.elvish}/bin/elvish
  programs.tmux = {
    enable = true;
    escapeTime = 10;
    keyMode = "vi";
    terminal = "screen-256color";
    extraConfig = ''
      set -g default-command ${pkgs.nushell}/bin/nu
      set -g default-shell ${pkgs.nushell}/bin/nu

      set-option -sa terminal-overrides ",xterm*:RGB"
      set-option -g focus-events on

      set-option -g update-environment "DISPLAY WAYLAND_DISPLAY SWAYSOCK SSH_AUTH_SOCK"

      # Pane movement
      bind-key j command-prompt -p "join pane from:"  "join-pane -s '%%'"
      bind-key g command-prompt -p "send pane to:"  "join-pane -t '%%'"
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
  #services.clamav = {
    #daemon.enable = true;
    #updater.enable = true;
  #};
}
