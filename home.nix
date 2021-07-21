{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # pass
    pass
    qtpass
  ];

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

  home.file.".vimrc".source = ./vimrc;
  home.file.".vim" = {
    source = ./vim;
    recursive = true;
  };
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [
      ale
    ];
  };
}
