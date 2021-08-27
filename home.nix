{ config, pkgs, ... }:

let
  omnisharp-vim = pkgs.vimUtils.buildVimPlugin
  {
    name = "omnisharp-vim";
    src = pkgs.fetchFromGitHub {
      #owner = "OmniSharp";
      owner = "lrdickson";
      repo = "Omnisharp-vim";
      rev = "e872388fae59bdb078abf4aa23c29b4acf36d464";
      sha256 = "sha256-ltsjCbX8w2eqj0LCW/BbW0YXMZJo15YchtEkVtqm8o0=";
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
        lightline-vim
        nerdcommenter
	nnn-vim
        omnisharp-vim
        rainbow
        rust-vim
        taglist-vim
	vim-autoformat
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
    file
    mono
    nnn # terminal file manager
    omnisharp-roslyn
    pandoc
    python
    universal-ctags
    vifm
  ];

  # bashrc
  programs.bash = {
    enable = true;
    # Add nnn change directory on quit
    bashrcExtra = builtins.readFile (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/jarun/nnn/v4.2/misc/quitcd/quitcd.bash_zsh";
    });
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
