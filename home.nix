{ config, pkgs, ... }:

let
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
  importPersonalComputer =
    if options.personalComputer then [ ./personal-computer-home.nix ] else [];
  importWsl =
    if options.wsl then [ ./wsl-home.nix ] else [];
  gitstatusd-linux-x86_64 = pkgs.runCommandLocal "gsd" {} ''
    mkdir $out
    ln -s ${pkgs.gitstatus}/bin/gitstatusd $out/gitstatusd-linux-x86_64
    '';
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

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
    };
  };

  # tmux settings
  programs.tmux = {
    enable = true;
    keyMode = "vi";
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
  # Stop powerlevel10k from complaining about gitstatusd
  #home.file.".cache/gitstatus".source = "${gitstatusd-linux-x86_64}";
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    #enableSyntaxHighlighting = true;
    autocd = true;
    initExtra =
      builtins.readFile ./bash_zsh_init/nnn_quitcd.bash_zsh +
      builtins.readFile ./bash_zsh_init/rga-fzf.bash_zsh;
    profileExtra = ''
      export DRACULA_ARROW_ICON=">"
      export DRACULA_DISPLAY_CONTEXT=1
      [ -f "$HOME/.bash_profile_extra" ] && . "$HOME/.bash_profile_extra"
    '';
    zplug = {
      enable = true;
      plugins = [
        #{ name = "mafredri/zsh-async"; }
        #{ name = "sindresorhus/pure"; tags = [ use:pure.zsh as:theme ]; }
        #{ name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
        { name = "dracula/zsh"; tags = [ as:theme ]; }
      ];
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "dirhistory"
        "history"
        "vi-mode"
      ];
    };
  };
}
