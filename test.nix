  programs.vim_configurable.package =  pkgs.vim_configurable.customize {
    name = "vim";
    vimrcConfig.plug.plugins = with pkgs.vimPlugins; [
      ale
      lightline-vim
      nerdcommenter
      rainbow
      rust-vim
      taglist-vim
      vim-gitgutter
      vim-plug
      vim-surround
    ];
    vimrcConfig.customRC = builtins.readFile ./vimrc;
  };

