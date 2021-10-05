{ config, pkgs, ... }:

let
importNonNixos =
  if options.nonNixos then [ ./home_manager/non-nixos-home.nix ] else [];
importPersonalComputer =
  if options.personalComputer then [ ./home_manager/personal-computer-home.nix ] else [];
importWsl =
  if options.wsl then [ ./home_manager/wsl-home.nix ] else [];
nnn-git = pkgs.fetchFromGitHub {
  owner = "jarun";
  repo = "nnn";
  rev = "f6856f61f74977a7929a601a4fc28168d2cc043c";
  sha256 = "1zd6vnbb08fslyk7grbkp1lg31jci9ryway02ms4bw54xvaqf4d3";
};
nonNixosBashProfile =
  if options.nonNixos then builtins.readFile ./home_manager/bash_profile/non_nixos_bash_profile.sh else "";
omnisharp-vim = pkgs.vimUtils.buildVimPlugin
{
  name = "omnisharp-vim";
  src = pkgs.fetchFromGitHub {
    owner = "OmniSharp";
    repo = "Omnisharp-vim";
    rev = "ab6348c61211fb88bad19a1e89ee65ec3243f0b7";
    sha256 = "sha256-FgoesU0PihWGzS9eq0GlLlHtV9AwEpGghvahZ4rwnJQ=";
  };
};
options = import ./defaultOptions.nix // import ./options.nix;
vimCommonPlugins = with pkgs.vimPlugins; [
      ale
      awesome-vim-colorschemes
      fzf-vim
      lightline-vim
      nerdcommenter
      nnn-vim
      omnisharp-vim
      rainbow
      rust-vim
      tagbar
      vim-autoformat
      vim-fish
      vim-fugitive
      vim-gitgutter
      vim-gutentags # Automatically generates tag files
      vim-nix # Fixes nix syntax highlighting for nvim
      vim-surround
    ];
vimConfiguration =
{
  enable = true;
};
vimConfigFiles = {
  source = ./home_manager/vim;
  recursive = true;
};
vimrc = (builtins.readFile ./home_manager/vimrc) + ''
  let g:OmniSharp_server_path = '${pkgs.omnisharp-roslyn}/bin/omnisharp'
'';
wslBashProfile =
  if options.wsl then builtins.readFile ./home_manager/bash_profile/wsl_bash_profile.sh else "";
wslFishInit =
  if options.wsl then builtins.readFile ./home_manager/fish/wsl.fish else "";
in
{
  imports = importNonNixos ++ importPersonalComputer ++ importWsl;

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    # Command line
    dotnet-sdk
    file # Provide information about a file
    html-tidy # Formatter for HTML
    mono # open source dotnet framework implementation
    neofetch # Display a the distro logo
    nnn # terminal file manager
    omnisharp-roslyn # C# linting engine
    pandoc # universal document converter
    python
    python39Packages.sqlparse # For vim SQL formatting
    ripgrep
    ripgrep-all
    screen # terminal multiplexer
    sqlint
    universal-ctags
    unzip
    w3m # terminal web browser
    zip

    # GUI
    sakura
    zettlr

    # latex support
    texlive.combined.scheme-small
  ];

  # Add icons to nnn
  nixpkgs.overlays = [
    ( self: super: { nnn = super.nnn.override { withNerdIcons = true; };})
  ];

  # bashrc
  programs.bash = {
    enable = true;
    # Add nnn change directory on quit
    bashrcExtra =
      builtins.readFile "${nnn-git}/misc/quitcd/quitcd.bash_zsh" +
      builtins.readFile ./home_manager/bash_zsh_init/rga-fzf.bash_zsh + ''
        # Set neovim as the default editor
        export EDITOR=nvim

        # Fix terminal colors
        export TERM=xterm-256color

        # Make NNN easier to read
        export NNN_COLOR='6666'

        # Source .bashrc_extra if it exists
        [ -f "$HOME/.bashrc_extra" ] && . "$HOME/.bashrc_extra"
      ''
      ;
      profileExtra = ''
        [ -f "$HOME/.bash_profile_extra" ] && . "$HOME/.bash_profile_extra"
      '' + wslBashProfile + nonNixosBashProfile;
    };

  # Fish
  programs.fish = {
    enable = true;
    functions = {
      rga-fzf = builtins.readFile ./home_manager/fish/rga-fzf.fish;
    };
    interactiveShellInit = ''
      # Fix terminal colors
      set -x TERM xterm-256color

      # Turn on vi keybindings
      fish_vi_key_bindings

      # Make NNN easier to read
      set -x NNN_COLORS 6666
    '' + builtins.readFile "${nnn-git}/misc/quitcd/quitcd.fish";
    shellInit = ''
      # Set the default editor
      export EDITOR=nvim

      # Source fish_init_extra if it exists
      if test -f "$HOME/.fish_init_extra"
        . "$HOME/.fish_init_extra"
      end
    '';
  };

  # fzf
  programs.fzf.enable = true;

  # Git settings
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    ignores = [
      "*~"
      "*.swp"
    ];
    extraConfig = {
      core = {
        # Fix git for cross collaboration with Windows
        autocrlf = "input";

        # nvim as default editor
        editor = "nvim";
      };

      # Set merge as the default pull action
      pull.rebase = false;
    };
  };

  # Ignore case in bash tab completion
  programs.readline = {
    enable = true;
    extraConfig = ''
      set completion-ignore-case On
    '';
  };

  programs.ssh = {
    enable = true;
    # Stop git from complaining about gitlab
    extraConfig = ''
      Host gitlab.com
        UpdateHostKeys no
    '';
  };

  # Starship settings
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    settings = {
      character = if options.wsl then {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
        vicmd_symbol = "[<](bold green)";
      } else {};
      git_status = if options.wsl then {
        ahead = ">";
        behind = "<";
        diverged = "<=>";
        deleted = "x";
      } else {};
      time.disabled = false;
    };
  };

  # tmux settings
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.fish}/bin/fish";
  };

  # Vim settings
  home.file.".vim" = vimConfigFiles;
  home.file.".config/nvim" = vimConfigFiles;
  programs = {
    # vim
    vim = (vimConfiguration // {
      extraConfig = vimrc + ''
        colorscheme darkblue
      '';
      plugins = vimCommonPlugins;
    });
    # neovim
    neovim = (vimConfiguration // {
      extraConfig = vimrc + ''
        colorscheme solarized8_high
      '';
      plugins = vimCommonPlugins ++ (with pkgs.vimPlugins; [
        ultisnips
      ]);
    });
  };
}
