{ config, lib, ... }:

{
  options = {
    sshShortcuts.enable = lib.mkEnableOption "enables ssh server shortcuts"; 
    _1passwordAgentPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "path to 1password ssh agent socket";
    };
  };

  config = lib.mkIf config.sshShortcuts.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "*" = lib.mkIf (config._1passwordAgentPath != null) {
          identityAgent = "\"${config._1passwordAgentPath}\"";
        };
        "ubuntu" = {
          hostname = "192.168.0.210";
          user = "ericgroom";
        };
        "infra" = {
          hostname = "192.168.0.208";
          user = "ericgroom";
        };
      };
    };
  };
}
