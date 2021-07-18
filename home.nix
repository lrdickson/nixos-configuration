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
}
