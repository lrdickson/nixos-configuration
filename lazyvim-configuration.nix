{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    neovim
    git
    lazygit
    gcc
    curl
    python3
    lua51Packages.lua
    lua51Packages.luarocks
    lua51Packages.lua-lsp
    tree-sitter
    nodejs


    # fzf-lua
    fzf
    ripgrep
    fd
  ];
}
