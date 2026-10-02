{pkgs, ...}:

{
  home.packages = [
    pkgs.herdr
  ];
  programs.mise = {
    enable = true;
    enableFishIntegration = true;
  };
}
