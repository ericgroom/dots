{ config, ... }:

let onePassPath = "${config.home.homeDirectory}/.1password/agent.sock"; in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        identityAgent = onePassPath;
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
}
