{ config, pkgs, ... }:

let
  omnisharp-vim = pkgs.vimUtils.buildVimPlugin
  {
    name = "omnisharp-vim";
    src = pkgs.fetchFromGitHub {
      owner = "OmniSharp";
      repo = "Omnisharp-vim";
      rev = "390c8880f6c6d2a3ba24f18c045770aba39d126f";
      sha256 = "1i19996h92dx5c6v9hmv62cg0y3a20ph2wv94r7fqf9db0izlcf7";
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
        lightline-vim
        nerdcommenter
        #omnisharp-vim
        rainbow
        rust-vim
        taglist-vim
        vim-gitgutter
        vim-surround
      ];
    };
  vimConfigFiles = {
    source = ./vim;
    recursive = true;
  };
  vimPlugRepo = builtins.fetchGit {
    url = "https://github.com/junegunn/vim-plug.git";
    ref = "master";
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
    omnisharp-roslyn
    pandoc
    python
    universal-ctags
  ];

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
