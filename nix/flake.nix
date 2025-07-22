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
        pkgs.fzf
        pkgs.fd
        pkgs.nix-search-cli
        pkgs.git
        pkgs.gh
        pkgs.tokei
        pkgs.mise
        pkgs.ripgrep
        pkgs.stow
        pkgs.fish
        (pkgs.fishPlugins.pure.overrideAttrs {
          nativeCheckInputs = [];
          checkPlugins = [];
          checkPhase = "";
        })
        pkgs.fish-lsp
        pkgs.nixd
        pkgs.wget
        pkgs.nodejs
        pkgs.xcodes
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

        brews = [
          "neovim"
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

      # Home Manager configuration
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ericgroom = {
        home.stateVersion = "23.11";
        
        # Start with a simple git configuration (email configured manually per system)
        programs.git = {
          enable = true;
          userName = "Eric Groom";
        };

        # Fish shell configuration
        programs.fish = {
          enable = true;
          shellInit = ''
            eval "$(mise activate fish)"
            fish_add_path ~/bin
            set -gx EDITOR nvim
            set -gx GIT_EDITOR nvim
          '';
          shellAliases = {
            # Git aliases
            g = "nvim -c 'Git | wincmd o' .";
            gs = "git status";
            gco = "git checkout";
            gl = "git log --oneline";
            gcb = "git checkout -b";
            gbl = "git branch | cat";
            gbd = "git branch -d";
            gc = "git for-each-ref --format='%(refname:short)' refs/heads | fzf | xargs git checkout";
            gb = "git for-each-ref --sort=committerdate refs/heads/ --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'";
            ga = "git ls-files --modified | fzf -m | xargs git add";
            gct = "git --no-pager tag --list | fzf | xargs git checkout";
          };
          functions = {
            c = ''
              set -f dir (fd -t d | fzf)
              cd $dir
            '';
            gsize = ''
              set -f branch $argv[1]
              git diff --shortstat --color $branch | cat
            '';
          };
        };

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
    };
    workConfig = {pkgs, ...}: {
      nixpkgs.hostPlatform = "aarch64-darwin";

      environment.systemPackages = [
        pkgs.git-standup
        pkgs.bruno
        pkgs.slack
        pkgs.claude-code
        # Docker
        pkgs.docker
        pkgs.docker-buildx
        pkgs.docker-compose
        pkgs.colima
      ];

      # ARM Mac homebrew setup
      home-manager.users.ericgroom.programs.fish.shellInit = pkgs.lib.mkBefore ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
      home-manager.users.ericgroom.programs.fish.shellAliases = pkgs.lib.mkAfter {
        nota = "cd ~/dev/Notability/";
      };

      homebrew = {
        brews = [
          "libyaml" # needed for ruby/bundler
          "postgresql@14"
          "redis"
        ];

        casks = [
          "elgato-stream-deck"
          "sf-symbols"
          "twobird"
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
        home-manager.darwinModules.home-manager
        shared
        workConfig
      ];
    };
    darwinConfigurations.personalmacbook = nix-darwin.lib.darwinSystem {
      modules = [
        mac-app-util.darwinModules.default
        home-manager.darwinModules.home-manager
        shared
        personalConfig
      ];
    };
  };
}
