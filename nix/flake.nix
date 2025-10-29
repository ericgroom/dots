{
  description = "Work Mac Config";

  inputs = {
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
  };

  outputs = inputs@{ self, lix-module, nix-darwin, home-manager, mac-app-util, apple-fonts, nixpkgs }:
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
      system.primaryUser = "ericgroom";

      fonts.packages = [ apple-fonts.packages.${pkgs.system}.sf-mono-nerd ];

      programs.fish.enable = true;
      environment.shells = [ pkgs.fish ];

      environment.systemPackages = [
        # General
        pkgs.nix-search-cli
        pkgs.git
        pkgs.gh
        pkgs.jujutsu
        pkgs.tokei
        pkgs.mise
        pkgs.stow
        pkgs.fish
        (pkgs.fishPlugins.pure.overrideAttrs {
          nativeCheckInputs = [];
          checkPlugins = [];
          checkPhase = "";
        })
        pkgs.nodejs
        pkgs.xcodes
        pkgs.spotify
      ];

      homebrew = {
        enable = true;
        onActivation = {
          cleanup = "uninstall";
          autoUpdate = true;
          upgrade = true;
        };

        taps = [
          "homebrew/services"
        ];

        casks = [
          "iterm2"
          "leader-key"
          "1password"
          "firefox"
          "mos"
          "private-internet-access"
        ];
      };

      security.pam.services.sudo_local.touchIdAuth = true;
      
      system.defaults.finder.CreateDesktop = false;
      system.defaults.finder.FXPreferredViewStyle = "clmv";
      system.defaults.finder.NewWindowTarget = "Home";
    };
    workConfig = {pkgs, ...}: {
      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.systemPackages = [
        pkgs.git-standup
        pkgs.bruno
        pkgs.slack
        pkgs.claude-code
      ];

      # ARM Mac homebrew setup
      home-manager.users.ericgroom.programs.fish.shellInit = pkgs.lib.mkBefore ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';

      homebrew = {
        brews = [
          "libyaml" # needed for ruby/bundler
          "postgresql@14"
          "redis"
        ];

        casks = [
          "elgato-stream-deck"
          "sf-symbols"
          "visual-studio-code"
          "db-browser-for-sqlite"
        ];
      };
    };
    personalConfig = {pkgs, ...}: {
      nix.enable = false;
      nixpkgs.hostPlatform = "x86_64-darwin";

      environment.systemPackages = [ ];

      # Intel Mac homebrew setup
      home-manager.users.ericgroom.programs.fish.shellInit = pkgs.lib.mkBefore ''
        eval "$(/usr/local/bin/brew shellenv)"
      '';
    };
  in 
  {
    darwinConfigurations.egroomm4 = nix-darwin.lib.darwinSystem {
      modules = [
        lix-module.nixosModules.default
        mac-app-util.darwinModules.default
        shared
        workConfig
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ericgroom = import ./home;
        }
        ./modules/darwin/docker.nix
      ];
    };
    darwinConfigurations.personalmacbook = nix-darwin.lib.darwinSystem {
      modules = [
        mac-app-util.darwinModules.default
        shared
        personalConfig
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ericgroom = import ./home;
        }
        ./modules/darwin/docker.nix
        ./modules/common_cli.nix
      ];
    };
    nixosConfigurations.desktop = import ./hosts/desktop inputs;
  };
}
