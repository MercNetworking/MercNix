{ ... }:
{
  # Placeholder — Steam Deck via Jovian-NixOS. Currently unused; not wired
  # into flake.nixosConfigurations yet (see modules/flake/hosts.nix).
  #
  # To bring it online: uncomment the `jovian` flake input in flake.nix,
  # import `inputs.jovian.nixosModules.default` (done for you in
  # modules/flake/hosts.nix once uncommented), set
  # `jovian.steam.enable = true;` and `jovian.steamos.enableBigscreen = true;`
  # here, then generate hardware-configuration.nix on the Deck itself.
  networking.hostName = "Mohg";

  system.stateVersion = "25.05";
}
