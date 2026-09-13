# Thunar lives at the system level (modules/nixos/desktop-common.nix) since
# it needs gvfs wired up system-wide. Kitty is purely per-user.
{ ... }:
{
  flake.modules.homeManager.terminal-apps = { ... }: {
    programs.kitty = {
      enable = true;
      settings = {
        confirm_os_window_close = 0;
      };
    };
  };
}
