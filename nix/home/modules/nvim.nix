{ config, pkgs, ...}:
{
  programs.neovim = {
    enable = true;

    extraPackages = with pkgs; [
      fzf
      nodejs
      gcc # needed for fzf native :shrug:

      fish-lsp
      nixd
    ];
  };

  xdg.configFile."nvim".source = ../../../nvim/.config/nvim;
}
