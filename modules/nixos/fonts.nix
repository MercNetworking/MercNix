# Default font on every host, GUI or headless: JetBrains Mono, patched as a
# Nerd Font so its icon glyphs (devicons, Powerline, Font Awesome, etc.) are
# baked in — no separate "icon font" install needed for bars/terminals/editors
# that expect them. font-awesome stays too, for anything that references
# "Font Awesome" by family name directly rather than a Nerd Font glyph.
{ ... }:
{
  flake.modules.nixos.fonts = { pkgs, ... }: {
    fonts = {
      enableDefaultPackages = true;

      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        liberation_ttf
        dejavu_fonts
        font-awesome
      ];

      fontconfig.defaultFonts = {
        serif = [ "Noto Serif" "Liberation Serif" ];
        sansSerif = [ "Noto Sans" "Liberation Sans" ];
        monospace = [ "JetBrainsMono Nerd Font" "JetBrainsMono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
