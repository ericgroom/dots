{
  description = "Work Mac Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = {pkgs, ...}: {
      services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.ericgroom = {
        name = "ericgroom";
        home = "/Users/ericgroom";
        shell = pkgs.fish;
      };

      programs.fish.enable = true;

      environment.systemPackages = [ ];

      security.pam.enableSudoTouchIdAuth = true;
    };
  in 
  {
    darwinConfigurations.egroomm4 = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
      ];
    };
  };
}
