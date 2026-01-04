{ config, lib, pkgs, ... }:

{

  options = {
    iosdev.enable = lib.mkEnableOption "install ios development tools";
  };

  config = lib.mkIf config.iosdev.enable {
    environment.systemPackages = [
      pkgs.xcodes
    ];
  };
}
