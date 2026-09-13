# The closest Nix equivalent to Proxmox: there's no single "Proxmox in a
# box" package, because on NixOS the hypervisor, the container runtime, and
# the web UI are three separate, composable pieces instead of one bundled
# distro. This module wires them together:
#
#   - libvirt/QEMU  -> the actual VM hypervisor (same engine Proxmox uses
#                       under the hood). Vyke is headless, so there's no
#                       local virt-manager/spice-gtk here — manage it
#                       remotely, either with virt-manager on Malenia/Radahn
#                       pointed at qemu+ssh://mercury@vyke/system, or
#                       through Cockpit below.
#   - Podman        -> the container runtime (Proxmox's "CT" equivalent —
#                       lighter than a full VM, still isolated). NixOS also
#                       has native declarative containers via
#                       `containers.<name>` (systemd-nspawn) if you want
#                       something even more "off the shelf Nix" for a
#                       specific container; add those directly here as your
#                       homelab grows.
#   - Cockpit       -> the web dashboard, with the `cockpit-machines`,
#                       `cockpit-podman`, and `cockpit-storaged` pages
#                       installed — this is the part that actually looks
#                       and feels like Proxmox's UI. Reachable at
#                       https://vyke:9090 once the host is up (or via
#                       Tailscale from anywhere on the tailnet).
{ ... }:
{
  flake.modules.nixos.homelab-virt = { pkgs, ... }: {
    # VMs. As of current nixpkgs, QEMU bundles every OVMF firmware variant
    # (including Secure-Boot-capable ones) and libvirtd auto-discovers
    # them — there's no `qemu.ovmf.*` option to set anymore (it's been
    # removed upstream and is now a hard error if touched).
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = false;
        swtpm.enable = true;
      };
    };

    # Containers
    virtualisation.containers.enable = true; # common config in /etc/containers
    virtualisation.podman = {
      enable = true;
      dockerCompat = true; # `docker` becomes an alias for `podman`
      defaultNetwork.settings.dns_enabled = true;
    };

    # Declarative NixOS containers (systemd-nspawn) are available too —
    # add entries under `containers.<name> = { ... };` here as needed.
    boot.enableContainers = true;

    # Web dashboard
    services.cockpit = {
      enable = true;
      openFirewall = true;
      settings.WebService.AllowUnencrypted = false;
    };

    environment.systemPackages = with pkgs; [
      cockpit-machines
      cockpit-podman
      cockpit-storaged
    ];

    users.users.mercury.extraGroups = [ "libvirtd" "podman" ];
  };
}
