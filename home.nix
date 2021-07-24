{ pkgs, ... }:

let
  vimConfiguration =
    {
      enable = true;
      extraConfig = builtins.readFile ./vimrc;
      plugins = with pkgs.vimPlugins; [
        ale
        lightline-vim
        nerdcommenter
        rainbow
        taglist-vim
        vim-gitgutter
        vim-plug
        vim-surround
      ];
    };
  vimPlugRepo = builtins.fetchGit {
    url = "https://github.com/junegunn/vim-plug.git";
    ref = "master";
  };
in
{
  home.packages = with pkgs; [
    dotnet-sdk
    mono
    omnisharp-roslyn
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

  # Vim settings
  home.file.".vim/filetype.vim".source = ./vim/filetype.vim;
  home.file.".vim/ftplugin" = {
    source = ./vim/ftplugin;
    recursive = true;
  };
  home.file.".vim/autoload/plug.vim".source =
    "${vimPlugRepo}/plug.vim";
  programs = {
    vim = (vimConfiguration // {});
    neovim = (vimConfiguration // {});
  };
}
