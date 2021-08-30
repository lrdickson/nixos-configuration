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
  vimConfiguration =
    {
      enable = true;
      extraConfig = (builtins.readFile ./vimrc) + ''
        let g:OmniSharp_server_path = '${pkgs.omnisharp-roslyn}/bin/omnisharp'
      '';
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
        vim-autoformat
        vim-fugitive
        vim-gitgutter
        vim-surround
      ];
    };
    vimConfigFiles = {
      source = ./vim;
      recursive = true;
    };
        in
        {
          imports = [
            ./home-manager-options.nix
          ];

          home.packages = with pkgs; [
            dotnet-sdk
            file # Provide information about a file
            mono
            nnn # terminal file manager
            omnisharp-roslyn
            pandoc
            python
            ripgrep
            ripgrep-all
            universal-ctags
            w3m # terminal web browser
          ];

  # bashrc
  programs.bash = {
    enable = true;
    # Add nnn change directory on quit
    bashrcExtra =
      builtins.readFile ./bashrc/nnn_quitcd.bash_zsh +
      builtins.readFile ./bashrc/rga-fzf.bash_zsh;
    profileExtra = ''
      if [ test -f "$HOME/.bash_profile_extra" ]; then
        . "$HOME/.bash_profile_extra"
      fi
      '';
    };

  # fzf
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
  };

  # Git settings
  programs.git = {
    enable = true;
    ignores = [
      "*~"
      "*.swp"
    ];
    extraConfig = {
      core = {
        # Fix git for cross collaboration with Windows
        autocrlf = "input";

        # vim as default editor
        editor = "vim";
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
    vim = (vimConfiguration // {});
    neovim = (vimConfiguration // {});
  };
}
