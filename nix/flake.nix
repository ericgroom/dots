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
      nix.enable = false;
      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
      nixpkgs.config = {
        allowUnfree = true;
      };

      users.users.ericgroom = {
        name = "ericgroom";
        home = "/Users/ericgroom";
        shell = pkgs.fish;
      };

      programs.fish.enable = true;
      environment.shells = [ pkgs.fish ];

      environment.systemPackages = [
        pkgs.tokei
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [
          "homebrew/services"
        ];

        brews = [
          "coreutils"
          "fzf"
          "git"
          "gh"
          "mise"
          "neovim"
          "ripgrep"
          "stow"
          "xcodes"

          "colima"
          "docker"
          "docker-buildx"
          "docker-compose"
          "postgresql@14"
          "redis"
        ];

        casks = [
          "1password"
          "elgato-stream-deck"
          "firefox"
          "iterm2"
          "mos"
          "sf-symbols"
          "slack"
          "twobird"
          "visual-studio-code"
        ];
      };

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
