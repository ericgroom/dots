{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fzf
    fd
    ripgrep
    wget
  ];
}
