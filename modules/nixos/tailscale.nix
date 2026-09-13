# Tailscale on every device so they can all reach each other (and remote
# applications on each other) over the same tailnet, wherever they
# physically are.
{ ... }:
{
  flake.modules.nixos.tailscale = { ... }: {
    services.tailscale.enable = true;

    # Treat the tailnet as trusted so traffic to/from it isn't hairpinned
    # through the regular firewall rules — needed for remote apps/exit
    # nodes/subnet routes to behave.
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
    networking.firewall.checkReversePath = "loose";
  };
}
