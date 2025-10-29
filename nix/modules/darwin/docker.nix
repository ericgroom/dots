{ pkgs, home-manager, ... }:
{
  environment.systemPackages = [
    pkgs.docker
    pkgs.docker-buildx
    pkgs.docker-compose
    pkgs.colima
  ];

  home-manager.users.ericgroom = {
    # sym link docker plugins
    home.file.".docker/cli-plugins/docker-buildx" = {
      source = "${pkgs.docker-buildx}/bin/docker-buildx";
      executable = true;
    };
    home.file.".docker/cli-plugins/docker-compose" = {
      source = "${pkgs.docker-compose}/bin/docker-compose";
      executable = true;
    };
  };
}
