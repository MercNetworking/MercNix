# Toggleable sysadmin stack for self-study. Off by default — flip it on
# per-host with `mercnix.sysadmin.enable = true;`.
#
# The day-to-day toolkit: process/resource monitoring, disk usage,
# networking diagnostics, backups, and basic intrusion prevention.
{ ... }:
{
  flake.modules.nixos.stack-sysadmin =
    { config, lib, pkgs, ... }:
    let
      cfg = config.mercnix.sysadmin;
    in
    {
      options.mercnix.sysadmin.enable = lib.mkEnableOption "the sysadmin learning stack";

      config = lib.mkIf cfg.enable {
        # A gentler, more mainstream alternative to fail2ban with the same
        # goal — ban IPs after repeated failed logins.
        services.fail2ban.enable = true;

        environment.systemPackages = with pkgs; [
          # Monitoring
          htop
          btop
          glances

          # Disk / filesystem
          ncdu
          tree
          smartmontools

          # Networking diagnostics
          mtr
          iperf3
          lsof
          iotop

          # Sync / backup
          rsync
          borgbackup
          restic

          # Terminal multiplexing
          tmux
        ];
      };
    };
}
