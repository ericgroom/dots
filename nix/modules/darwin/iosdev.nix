{ config, lib, ... }:

{

  options = {
    iosdev.enable = lib.mkEnableOption "install ios development tools";
  };

  config = lib.mkIf config.iosdev.enable {
    homebrew.brews = [
      "xcodes"
      "aria2"  # speeds up Xcode downloads
    ];
  };
}
