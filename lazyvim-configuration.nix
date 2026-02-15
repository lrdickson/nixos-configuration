{ config, lib, pkgs, ... }:
let
  sources = import ./npins;
  unstable = import sources.nixpkgs-unstable { config = { allowUnfree = true; }; };
in {
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
    lua51Packages.luarocks
    neovim
    nodejs
    python3
    tree-sitter
    universal-ctags # For tags generation

    # Formatters
    nixfmt-classic
    stylua

    # language servers
    lsp-ai
    ltex-ls # latex and markdown lsp, with spell checking
    lua-language-server
    lua51Packages.lua-lsp
    marksman # markdown lsp
    nixd # official nix language server
    taplo # toml lsp

    unstable.markdown-oxide

    # fzf-lua
    fd
    fzf
    ripgrep

    # Avante
    gnumake
  ];
}
