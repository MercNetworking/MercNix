{ ... }:
{
  # Placeholder — homelab/server. Currently unused; not wired into
  # flake.nixosConfigurations yet (see modules/flake/hosts.nix, which
  # already lists the full feature set: homelab-virt, media-stack, and the
  # sysadmin/devops learning stacks — this file only needs to carry the
  # truly host-specific bits).
  #
  # To bring it online: run `nixos-generate-config` on the target hardware,
  # drop the resulting hardware-configuration.nix next to this file, and
  # uncomment the Vyke block in modules/flake/hosts.nix.
  networking.hostName = "Vyke";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  system.stateVersion = "25.05";
}
