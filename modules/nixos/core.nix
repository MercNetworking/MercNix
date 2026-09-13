# Baseline system settings shared by every NixOS host. Kept deliberately
# small — GUI-only concerns live in desktop-common.nix instead.
{ config, ... }:
{
  flake.modules.nixos.core = { pkgs, ... }: {
    imports = [
      config.flake.modules.nixos.fonts
      config.flake.modules.nixos.tailscale
      config.flake.modules.nixos.stack-cybersecurity
      config.flake.modules.nixos.stack-devops
      config.flake.modules.nixos.stack-sysadmin
    ];

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;

    time.timeZone = "America/Chicago";
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    networking.networkmanager.enable = true;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };

    # Nix is the only package manager/installer in this config — no
    # Flatpak, no Snap, no Homebrew.
    environment.systemPackages = with pkgs; [
      fastfetch
      git
      unzip
      unrar
      protonplus # Steam's Proton compatibility-layer manager — unrelated to the Proton privacy suite
      ookla-speedtest
      popsicle
    ];

    system.stateVersion = "25.05";
  };
}
