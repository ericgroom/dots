{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
    tree-sitter
    fzf
    gcc
    gnumake
    fish-lsp
    nixd
    lua-language-server
    stylua
    nodejs   # replaces withNodeJs
  ];

  home.sessionVariables.EDITOR = "nvim";

  xdg.configFile."nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dots/nvim/.config/nvim";
}
