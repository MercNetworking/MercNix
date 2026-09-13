# Per-user Noctalia (shell/bar) + Umbriel (compositor) configuration.
# Umbriel's system-level session registration lives in
# modules/nixos/umbriel-compositor.nix; this is the declarative
# ~/.config/{noctalia,umbriel}/config.toml.
#
# `systemd.enable = true` on Noctalia and Umbriel's `general.autostart`
# together mean the shell starts itself the moment you log in — no manual
# launch step needed.
{ inputs, ... }:
{
  flake.modules.homeManager.desktop-shell = { ... }: {
    imports = [
      inputs.noctalia.homeModules.default
      inputs.umbriel.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        shell.font = "JetBrainsMono Nerd Font";

        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        # Plugin support is on and both official sources are enabled, so
        # new plugins just need `noctalia msg plugins enable <author>/<name>`
        # (or Settings → Plugins) — nothing to touch here first.
        # Add your own git/path sources and drop plugin ids in `enabled`
        # as you pick them up.
        plugins = {
          enabled = [ ];
          auto_update = "all";
          source = [
            {
              name = "official";
              kind = "git";
              location = "https://github.com/noctalia-dev/official-plugins";
              enabled = true;
            }
            {
              name = "community";
              kind = "git";
              location = "https://github.com/noctalia-dev/community-plugins";
              enabled = true;
            }
          ];
        };
      };
    };

    programs.umbriel = {
      enable = true;

      settings = {
        general.autostart = [ "noctalia" ];

        keybinds = {
          "Mod+Return" = "spawn:kitty";
          "Mod+Q" = "window-close";
          "Mod+R" = "spawn:noctalia msg panel-toggle launcher";
        };
      };
    };
  };
}
