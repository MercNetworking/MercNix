{
  description = "MercNix — Hunter Welch's multi-system NixOS configuration (flake-parts / dendritic)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Recursively imports every .nix file under ./modules as a flake-parts
    # module. This is what makes the tree "dendritic": one file, one
    # feature, auto-wired — no central list of imports to keep in sync.
    import-tree.url = "github:vic/import-tree";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Noctalia ecosystem — the only shell/compositor/greeter in this config.
    # This is young, fast-moving software; if an option below has drifted,
    # check https://docs.noctalia.dev first.
    noctalia.url = "github:noctalia-dev/noctalia";
    noctalia.inputs.nixpkgs.follows = "nixpkgs";

    umbriel.url = "github:noctalia-dev/umbriel";
    umbriel.inputs.nixpkgs.follows = "nixpkgs";

    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
    noctalia-greeter.inputs.nixpkgs.follows = "nixpkgs";

    # Uncomment when Morgott (Darwin) actually needs nix-darwin instead of
    # (or in addition to) the standalone home-manager profile below.
    # nix-darwin.url = "github:LnL7/nix-darwin";
    # nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Uncomment when Mohg (Steam Deck) is wired up.
    # jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    # jovian.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" ];
      imports = [
        # Declares flake.modules.<class>.<name> as a real, mergeable option
        # (lazy attrset of lazy attrset of module) instead of a raw,
        # undeclared flake output — without this, every file that sets
        # flake.modules.nixos.* or flake.modules.homeManager.* collides
        # with every other one instead of merging.
        # https://flake.parts/options/flake-parts-modules.html
        inputs.flake-parts.flakeModules.modules

        (inputs.import-tree ./modules)
      ];
    };
}
