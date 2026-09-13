# The full arr stack, plus the pieces that feed and serve it. All state
# lives under /var/lib/<service>/ (each module's own default dataDir) so it
# survives rebuilds; back that directory up.
#
#   Prowlarr    (9696) -- indexer manager, feeds the rest
#   Sonarr      (8989) -- TV
#   Radarr      (7878) -- movies
#   Lidarr      (8686) -- music
#   Readarr     (8787) -- books
#   Bazarr      (6767) -- subtitles for Sonarr/Radarr
#   qBittorrent (8080) -- the actual download client
#   Jellyfin    (8096) -- media server the whole stack ultimately feeds
#
# All ports are opened on Vyke's own firewall only — reach them over
# Tailscale rather than exposing this host to the open internet.
{ ... }:
{
  flake.modules.nixos.media-stack = { ... }: {
    services.prowlarr = {
      enable = true;
      openFirewall = true;
    };

    services.sonarr = {
      enable = true;
      openFirewall = true;
    };

    services.radarr = {
      enable = true;
      openFirewall = true;
    };

    services.lidarr = {
      enable = true;
      openFirewall = true;
    };

    services.readarr = {
      enable = true;
      openFirewall = true;
    };

    services.bazarr = {
      enable = true;
      openFirewall = true;
    };

    services.qbittorrent = {
      enable = true;
      openFirewall = true;
    };

    services.jellyfin = {
      enable = true;
      openFirewall = true;
    };
  };
}
