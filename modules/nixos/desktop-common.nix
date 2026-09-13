# Shared by every GUI host (Malenia, Radahn). Builds on core + user.
{ config, ... }:
{
  flake.modules.nixos.desktop-common = { pkgs, ... }: {
    imports = [
      config.flake.modules.nixos.core
      config.flake.modules.nixos.user
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Audio / printing
    services.printing.enable = true;
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Thunar as the file manager — needs gvfs system-wide for trash,
    # network mounts, and removable-media handling. gvfs in turn needs
    # FUSE, which nixpkgs recently made opt-in rather than assuming every
    # consumer (gvfs included) enables it for itself.
    programs.fuse.enable = true;
    programs.thunar.enable = true;
    programs.thunar.plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    services.gvfs.enable = true;
    services.tumbler.enable = true; # thumbnails in Thunar

    programs.steam.enable = true;

    environment.systemPackages = with pkgs; [
      discord
      firefox
    ];
  };
}
