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

  users.users.ericgroom = {
    name = "ericgroom";
    home = "/Users/ericgroom";
    shell = pkgs.fish;
  };
  system.primaryUser = "ericgroom";

  fonts.packages = [ inputs.apple-fonts.packages.${pkgs.system}.sf-mono-nerd ];

  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  environment.systemPackages = [
    # General
    pkgs.nix-search-cli
    pkgs.tokei
    pkgs.fish
    (pkgs.fishPlugins.pure.overrideAttrs {
     nativeCheckInputs = [];
     checkPlugins = [];
     checkPhase = "";
     })
    pkgs.nodejs
    pkgs.spotify
  ];

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
      autoUpdate = true;
      upgrade = true;
    };

    casks = [
      "iterm2"
      "leader-key"
      "1password"
      "firefox"
      "mos"
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
