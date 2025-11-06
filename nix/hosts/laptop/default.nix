{ nix-darwin, home-manager, mac-app-util, ...}@inputs:

nix-darwin.lib.darwinSystem {
  system = "x86_64-darwin";
  specialArgs = { inherit inputs; };
  modules = [
    mac-app-util.darwinModules.default
    ./configuration.nix
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ericgroom = import ../../home;
    }
  ];
}
