{ pkgs, inputs, home-manager, ... }:

{
  imports = [
    ../../modules/darwin/docker.nix
    ../../modules/common_cli.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";
  nix.enable = false;
  nixpkgs.hostPlatform = "x86_64-darwin";

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
    pkgs.xcodes
    pkgs.spotify
  ];

  # # Intel Mac homebrew setup
  # home-manager.users.ericgroom.programs.fish.shellInit = pkgs.lib.mkBefore ''
  #   eval "$(/usr/local/bin/brew shellenv)"
  # '';

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
}
