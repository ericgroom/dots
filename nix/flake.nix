{
  description = "Nix computers' config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs = inputs@{ self, nix-darwin, mac-app-util, nixpkgs }:
  let
    shared = {pkgs, ...}: {
      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
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
        # General
        pkgs.fzf
        pkgs.git
        pkgs.gh
        pkgs.tokei
        pkgs.mise
        pkgs.ripgrep
        pkgs.stow
        pkgs.fish
        pkgs.fishPlugins.pure
        pkgs.nixd
        pkgs.wget

        pkgs.iterm2
        pkgs._1password
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [
          "homebrew/services"
        ];

        brews = [
          "neovim"
        ];

        casks = [
          "leader-key"
          "firefox"
          "mos"
        ];
      };

      security.pam.enableSudoTouchIdAuth = true;
    };
    workConfig = {pkgs, ...}: {
      nix.enable = false;
      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.systemPackages = [
        pkgs.git-standup
        pkgs.bruno
      ];

      homebrew = {
        brews = [
          "xcodes"

          "libyaml" # needed for ruby/bundler
          "colima"
          "docker"
          "docker-buildx"
          "docker-compose"
          "postgresql@14"
          "redis"
        ];

        casks = [
          "elgato-stream-deck"
          "sf-symbols"
          "slack"
          "twobird"
          "visual-studio-code"
        ];
      };
    };
    personalConfig = {...}: {
      nix.enable = false;
      nixpkgs.hostPlatform = "x86_64-darwin";

      environment.systemPackages = [ ];

      homebrew = {
        brews = [
          "xcodes"
        ];
      };
    };
  in 
  {
    darwinConfigurations.egroomm4 = nix-darwin.lib.darwinSystem {
      modules = [
        mac-app-util.darwinModules.default
        shared
        workConfig
      ];
    };
    darwinConfigurations.personalmacbook = nix-darwin.lib.darwinSystem {
      modules = [
        mac-app-util.darwinModules.default
        shared
        personalConfig
      ];
    };
  };
}
