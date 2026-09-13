# Morgott — Darwin / macOS (unused)

Morgott isn't a NixOS or nix-darwin system — it's a standalone home-manager
profile for macOS: `flake.homeConfigurations.Morgott` in
`modules/flake/hosts.nix`. That's why there's no `default.nix` here; the
whole "host" is just that commented-out block, built from the same
`flake.modules.homeManager.*` features as Malenia and Radahn (minus the
Linux-only desktop-shell module).

To bring it online:

1. Uncomment the `flake.homeConfigurations.Morgott` block in
   `modules/flake/hosts.nix`.
2. On the Mac: `nix run home-manager -- switch --flake .#Morgott`.

If full system management (not just dotfiles/apps) is ever wanted instead,
swap this for a real nix-darwin configuration — uncomment the `nix-darwin`
input in `flake.nix` and add a `Morgott = inputs.nix-darwin.lib.darwinSystem { ... }`
entry alongside the NixOS hosts.
