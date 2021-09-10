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

      # GUI
      sakura
    ];

  # bashrc
  programs.bash = {
    enable = true;
    # Add nnn change directory on quit
    bashrcExtra =
      builtins.readFile ./bashrc/nnn_quitcd.bash_zsh +
      builtins.readFile ./bashrc/rga-fzf.bash_zsh + ''
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

  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

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
}
