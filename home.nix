{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # pass
    pass
    qtpass
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
  home.file.".vimrc".source = ./vimrc;
  home.file.".vim" = {
    source = ./vim;
    recursive = true;
  };
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      ale
      vim-gitgutter
    ];
  };
}
