{ pkgs, inputs, home-manager, ... }:

{
  imports = [
    ../../modules/darwin/docker.nix
    ../../modules/darwin/iosdev.nix
    ../../modules/common_cli.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 6;
  nixpkgs.config = {
    allowUnfree = true;
  };
  nixpkgs.overlays = [
    (final: prev: {
      fishPlugins = prev.fishPlugins // {
        # pure's test suite assumes a Linux/non-sandboxed environment (/proc,
        # unrestricted git config, etc.) and fails under the Darwin Nix sandbox.
        pure = prev.fishPlugins.pure.overrideAttrs (_: { doCheck = false; });
      };
    })
  ];

  users.users.ericgroom = {
    name = "ericgroom";
    home = "/Users/ericgroom";
    shell = pkgs.fish;
  };
  system.primaryUser = "ericgroom";

  fonts.packages = [ inputs.apple-fonts.packages.${pkgs.stdenv.hostPlatform.system}.sf-mono-nerd ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  environment.systemPackages = [
    # General
    pkgs.nix-search-cli
    pkgs.tokei
    pkgs.fish
    pkgs.fishPlugins.pure
    pkgs.claude-code
    pkgs.nodejs
    pkgs.spotify
    pkgs._1password-cli
    pkgs.wireguard-ui
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };

    masApps = {
      things = 904280696;
      daisyDisk = 411643860;
      developer = 640199958;
      wireguard = 1451685025;
      numbers = 361304891;
      pages = 361309726;
    };

    brews = [
      "postgresql@16"
    ];

    casks = [
      "iterm2"
      "leader-key"
      "1password"
      "firefox"
      "mos"
      "pgadmin4"
      "discord"
    ];
  };

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    finder = {
      CreateDesktop = false;
      FXPreferredViewStyle = "clmv";
      NewWindowTarget = "Home";
    };
    dock = {
      autohide = true;
    };
  };

  home-manager.users.ericgroom.sshShortcuts.enable = true;
  home-manager.users.ericgroom._1passwordAgentPath = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock";

  iosdev.enable = true;
}
