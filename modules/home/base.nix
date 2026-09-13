{ ... }:
{
  flake.modules.homeManager.base = { ... }: {
    home.username = "mercury";
    home.homeDirectory = "/home/mercury";
    home.stateVersion = "25.05";

    # Drop wallpapers in ./Wallpapers at the repo root and uncomment to
    # have them symlinked in automatically:
    # home.file."Pictures/Wallpapers".source = ../../Wallpapers;
  };
}
