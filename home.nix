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
        vim-surround
      ];
    };
in
{
  home.packages = with pkgs; [
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
  home.file.".vim" = {
    source = ./vim;
    recursive = true;
  };
  programs = {
    vim = (vimConfiguration // {});
    neovim = (vimConfiguration // {});
  };
}
