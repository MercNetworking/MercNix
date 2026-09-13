# Windows 11 VM support, in the same spirit as Omarchy's approach: a
# libvirt/QEMU setup with virt-manager as the GUI, and an emulated TPM 2.0
# — Windows 11 hard-requires both Secure Boot and TPM 2.0 to install and
# run. As of current nixpkgs, QEMU bundles every OVMF firmware variant it
# ships (including Secure-Boot-capable ones) and libvirtd auto-discovers
# them — there used to be a `qemu.ovmf.*` option to configure this
# manually, but it's been removed upstream ("All OVMF images distributed
# with QEMU are now available by default") and setting it is now a hard
# error. Nothing to configure here: just pick a Q35 + UEFI (Secure Boot)
# firmware option in virt-manager when creating the VM.
{ ... }:
{
  flake.modules.nixos.win11-vm = { pkgs, ... }: {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        runAsRoot = false;
        swtpm.enable = true; # emulated TPM 2.0
      };
    };

    virtualisation.spiceUSBRedirection.enable = true;

    # Installs virt-manager and the polkit rules so it can be used without
    # running the whole session as root.
    programs.virt-manager.enable = true;

    environment.systemPackages = with pkgs; [
      virt-viewer
      spice-gtk
      win-virtio # VirtIO drivers ISO for the Windows guest
      win-spice # SPICE guest tools ISO for the Windows guest — installs the
                # guest-side agent that gives clipboard sharing/dynamic
                # resolution. spice-vdagentd itself runs inside the guest,
                # not here on the host.
    ];

    users.users.mercury.extraGroups = [ "libvirtd" ];
  };
}
