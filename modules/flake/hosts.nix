# The one place that wires named feature modules (flake.modules.nixos.*,
# flake.modules.homeManager.*) up into actual systems. Everything else in
# this repo just contributes a named module here; this file is the only
# one that has to know which hosts exist.
{ inputs, config, ... }:
let
  mercuryHomeProfile = [
    config.flake.modules.homeManager.base
    config.flake.modules.homeManager.shell
    config.flake.modules.homeManager.git-gh
    config.flake.modules.homeManager.zed
    config.flake.modules.homeManager.terminal-apps
    config.flake.modules.homeManager.dev-tools
    config.flake.modules.homeManager.apps
    config.flake.modules.homeManager.desktop-shell
  ];

  mkDesktopHost =
    { hardware, extraModules ? [ ], hostName }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        config.flake.modules.nixos.desktop-common
        config.flake.modules.nixos.umbriel-compositor
        config.flake.modules.nixos.noctalia-greeter
        config.flake.modules.nixos.win11-vm
        { networking.hostName = hostName; }
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.mercury.imports = mercuryHomeProfile;
        }
      ]
      ++ hardware
      ++ extraModules;
    };
in
{
  flake.nixosConfigurations = {
    # Malenia is the primary daily driver, so it's also where the toggleable
    # learning stacks are switched on — flip any of these to `false` (or
    # drop the block entirely) whenever you don't want a given stack
    # installed. See modules/nixos/stack-*.nix for what each one contains.
    Malenia = mkDesktopHost {
      hostName = "Malenia";
      hardware = [ ../../hosts/Malenia/hardware-configuration.nix ];
      extraModules = [
        ../../hosts/Malenia/intel-arc.nix
        {
          mercnix.cybersecurity.enable = true;
          mercnix.devops.enable = true;
          mercnix.sysadmin.enable = true;
        }
      ];
    };

    Radahn = mkDesktopHost {
      hostName = "Radahn";
      hardware = [ ../../hosts/Radahn/hardware-configuration.nix ];
      extraModules = [
        ../../hosts/Radahn/nvidia.nix
        { nixpkgs.config.nvidia.acceptLicense = true; }
        # Same toggles are available here — off by default so the laptop
        # stays lighter:
        # { mercnix.devops.enable = true; }
      ];
    };

    # ---- Inactive placeholders --------------------------------------
    # Only Malenia and Radahn are in active use today. The three below are
    # scaffolding for later — flip them on by uncommenting once real
    # hardware exists.

    # Vyke — homelab/server. Fully featured below (Nix's answer to
    # Proxmox for VMs/containers, the full arr stack, and the sysadmin/
    # devops learning stacks); it just needs real hardware to build against.
    # Run `nixos-generate-config` on the target and drop the resulting
    # hardware-configuration.nix into hosts/Vyke/.
    # Vyke = inputs.nixpkgs.lib.nixosSystem {
    #   specialArgs = { inherit inputs; };
    #   modules = [
    #     config.flake.modules.nixos.core
    #     config.flake.modules.nixos.user
    #     config.flake.modules.nixos.homelab-virt
    #     config.flake.modules.nixos.media-stack
    #     ../../hosts/Vyke/default.nix
    #     ../../hosts/Vyke/hardware-configuration.nix
    #     {
    #       mercnix.sysadmin.enable = true;
    #       mercnix.devops.enable = true;
    #       # mercnix.cybersecurity.enable = true; # only if you want the
    #       #                                       # pentest toolkit on the
    #       #                                       # server itself too
    #     }
    #   ];
    # };

    # Mohg — Steam Deck via Jovian-NixOS. Uncomment the `jovian` flake
    # input first, then generate hardware-configuration.nix on the Deck.
    # Mohg = inputs.nixpkgs.lib.nixosSystem {
    #   specialArgs = { inherit inputs; };
    #   modules = [
    #     inputs.jovian.nixosModules.default
    #     config.flake.modules.nixos.core
    #     config.flake.modules.nixos.user
    #     ../../hosts/Mohg/default.nix
    #     ../../hosts/Mohg/hardware-configuration.nix
    #   ];
    # };
  };

  # Morgott — Darwin/macOS, as a *standalone home-manager profile* (no
  # nix-darwin; just home-manager managing dotfiles/apps on top of
  # macOS). Uncomment once you're on real Darwin hardware. Note this
  # profile skips desktop-shell (Umbriel/Noctalia are Linux-only) and
  # Tailscale (that's a NixOS module — install the Tailscale macOS app
  # separately to join the same tailnet).
  # flake.homeConfigurations.Morgott = inputs.home-manager.lib.homeManagerConfiguration {
  #   pkgs = inputs.nixpkgs.legacyPackages.aarch64-darwin;
  #   extraSpecialArgs = { inherit inputs; };
  #   modules = [
  #     config.flake.modules.homeManager.base
  #     config.flake.modules.homeManager.shell
  #     config.flake.modules.homeManager.git-gh
  #     config.flake.modules.homeManager.zed
  #     config.flake.modules.homeManager.dev-tools
  #   ];
  # };
}
