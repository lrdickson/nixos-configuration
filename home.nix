{ config, pkgs, ... }:

let
  importPersonalComputer =
    if options.personalComputer then [ ./personal-computer-home.nix ] else [];
  importWsl =
    if options.wsl then [ ./wsl-home.nix ] else [];
  gitstatusd-linux-x86_64 = pkgs.runCommandLocal "gsd" {} ''
    mkdir $out
    ln -s ${pkgs.gitstatus}/bin/gitstatusd $out/gitstatusd-linux-x86_64
    '';
  nix-env-fish = pkgs.fetchFromGitHub {
    owner = "lilyball";
    repo = "nix-env.fish";
    rev = "00c6cc762427efe08ac0bd0d1b1d12048d3ca727";
    sha256 = "1hrl22dd0aaszdanhvddvqz3aq40jp9zi2zn0v1hjnf7fx4bgpma";
  };
  nnn-git = pkgs.fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "f6856f61f74977a7929a601a4fc28168d2cc043c";
    sha256 = "1zd6vnbb08fslyk7grbkp1lg31jci9ryway02ms4bw54xvaqf4d3";
  };

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
  vimConfiguration =
    {
      enable = true;
      plugins = with pkgs.vimPlugins; [
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
        ultisnips
        vim-autoformat
        vim-fugitive
        vim-gitgutter
        vim-gutentags # Automatically generates tag files
        vim-nix # Fixes nix syntax highlighting for nvim
        vim-surround
      ];
    };
  vimConfigFiles = {
    source = ./vim;
    recursive = true;
  };
  vimrc = (builtins.readFile ./vimrc) + ''
    let g:OmniSharp_server_path = '${pkgs.omnisharp-roslyn}/bin/omnisharp'
  '';
  wslBashProfile =
    if options.wsl then builtins.readFile ./bash_profile/wsl_bash_profile.sh else "";
  wslFishInit =
    if options.wsl then builtins.readFile ./fish/wsl.fish else "";
  in
  {
    imports = importPersonalComputer ++ importWsl;

    home.packages = with pkgs; [
      # Command line
      dotnet-sdk
      file # Provide information about a file
      html-tidy # Formatter for HTML
      mono # open source dotnet framework implementation
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

      # latex support
      texlive.combined.scheme-small

      # GUI
      sakura
      zettlr

      ion
      oil
    ];

  # bashrc
  programs.bash = {
    enable = true;
    # Add nnn change directory on quit
    bashrcExtra =
      builtins.readFile ./bash_zsh_init/nnn_quitcd.bash_zsh +
      builtins.readFile ./bash_zsh_init/rga-fzf.bash_zsh + ''
        # Set neovim as the default editor
        export EDITOR=nvim

        # Fix terminal colors
        export TERM=xterm-256color

        # Source .bashrc_extra if it exists
        [ -f "$HOME/.bashrc_extra" ] && . "$HOME/.bashrc_extra"
      ''
      ;
      profileExtra = ''
        [ -f "$HOME/.bash_profile_extra" ] && . "$HOME/.bash_profile_extra"
      '' + wslBashProfile;
    };

  # Add icons to nnn
  nixpkgs.overlays = [
    ( self: super: { nnn = super.nnn.override { withNerdIcons = true; };})
  ];

  # Fish
  home.file.".config/fish/conf.d/nix-env.fish".source =
    "${nix-env-fish}/conf.d/nix-env.fish";
  home.file.".config/fish/functions/n.fish".source =
    "${nnn-git}/misc/quitcd/quitcd.fish";
  programs.fish = {
    enable = true;
    functions = {
      rga-fzf = builtins.readFile ./fish/rga-fzf.fish;
    };
    shellInit = ''
      if test -f "$HOME/.fish_init_extra"
        . "$HOME/.fish_init_extra"
      end
    '';
    # + wslFishInit;
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

  # Ion
  home.file.".config/ion/" = {
    source = ./ion;
    recursive = true;
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

  programs.starship = {
    #enable = true;
    settings = {
      #add_newline = false;
      character = if options.wsl then {
        success_symbol = "[>](bold green)";
        error_symbol = "[>](bold red)";
        vicmd_symbol = "[<](bold green)";
      } else {};
      git_status = if options.wsl then {
        ahead = ">";
        behind = "<";
        diverged = "<=>";
      } else {};
      #hostname.ssh_only = false;
      #username.show_always = true;
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
    vim = (vimConfiguration // {
      extraConfig = vimrc + ''
        colorscheme solarized8_high
      '';
    });
    neovim = (vimConfiguration // {
      extraConfig = vimrc + ''
        colorscheme solarized8_high
      '';
    });
  };

  # zsh settings
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    #enableSyntaxHighlighting = true;
    autocd = true;
    initExtra =
      builtins.readFile ./bash_zsh_init/nnn_quitcd.bash_zsh +
      builtins.readFile ./bash_zsh_init/rga-fzf.bash_zsh;
    profileExtra = ''
      [ -f "$HOME/.bash_profile_extra" ] && . "$HOME/.bash_profile_extra"
    '' + wslBashProfile;
    zplug = {
      enable = true;
      plugins = [
      ];
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "vi-mode"
      ];
    };
  };
}
