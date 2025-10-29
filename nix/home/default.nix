{ config, pkgs, ... }:

{
  home.stateVersion = "23.11";
  home.username = "ericgroom";

  imports = [
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/nvim.nix
  ];
}
