{ config, lib, pkgs, ... }:

let
  unstable = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz") { };
in
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      packages.myVimPackage = with pkgs.vimPlugins; {
        # loaded on launch
        start = [ ];
        # manually loadable by calling `:packadd $plugin-name`
        opt = [ ];
      };
    };
  };
  environment.systemPackages = with pkgs; [
    curl
    gcc
    git
    lazygit
    lua51Packages.lua
    lua51Packages.lua-lsp
    lua51Packages.luarocks
    neovim
    nodejs
    python3
    tree-sitter

    # fzf-lua
    fd
    fzf
    ripgrep

    # Formatters
    stylua
  ];
}
