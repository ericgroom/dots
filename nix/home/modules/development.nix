{ pkgs, ... }:

{
  home.packages = [
    pkgs.herdr
    pkgs.claude-code
  ];
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
  };
}
