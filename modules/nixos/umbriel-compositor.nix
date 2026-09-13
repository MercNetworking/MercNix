# Umbriel is the only compositor in this config — a Wayland compositor
# (wlroots + SceneFX) that Noctalia pairs with as its shell.
# https://docs.noctalia.dev/umbriel/
{ inputs, ... }:
{
  flake.modules.nixos.umbriel-compositor = { ... }: {
    imports = [ inputs.umbriel.nixosModules.default ];

    # Registers the "umbriel" session with the display manager and wires up
    # xdg-desktop-portal-umbriel automatically.
    programs.umbriel.enable = true;
  };
}
