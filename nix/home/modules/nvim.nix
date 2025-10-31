{ config, pkgs, ...}:
{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withNodeJs = true;

    extraPackages = with pkgs; [
      tree-sitter
      fzf
      gcc # needed for fzf native :shrug:
      gnumake

      fish-lsp
      nixd
      lua-language-server
      stylua
    ];
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dots/nvim/.config/nvim";
}
