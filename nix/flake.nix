{
  description = "Work Mac Config";

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
    workConfig = {pkgs, ...}: {
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
        # General
        pkgs.fzf
        pkgs.git
        pkgs.git-standup
        pkgs.gh
        pkgs.tokei
        pkgs.mise
        pkgs.ripgrep
        pkgs.stow
        pkgs.fish
        pkgs.fishPlugins.pure

        pkgs.iterm2
        pkgs.bruno
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [
          "homebrew/services"
        ];

        brews = [
          "neovim"
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
          "leader-key"
          "1password"
          "elgato-stream-deck"
          "firefox"
          "mos"
          "sf-symbols"
          "slack"
          "twobird"
          "visual-studio-code"
        ];
      };

      security.pam.enableSudoTouchIdAuth = true;
    };
    personalConfig = {pkgs, ...}: {
      nix.enable = false;
      nix.settings.experimental-features = "nix-command flakes";

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "x86_64-darwin";
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

        pkgs.iterm2
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "uninstall";

        taps = [
          "homebrew/services"
        ];

        brews = [
          "neovim"
          "xcodes"
        ];

        casks = [
          "1password"
          "firefox"
        ];
      };

      security.pam.enableSudoTouchIdAuth = true;
    };
  in 
  {
    darwinConfigurations.egroomm4 = nix-darwin.lib.darwinSystem {
      modules = [
        mac-app-util.darwinModules.default
        workConfig
      ];
    };
    darwinConfigurations.personalmacbook = nix-darwin.lib.darwinSystem {
      modules = [
        mac-app-util.darwinModules.default
        personalConfig
      ];
    };
  };
}
