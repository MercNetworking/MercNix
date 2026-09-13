{ ... }:
{
  flake.modules.homeManager.apps = { pkgs, ... }: {
    home.packages = with pkgs; [
      spotify
      protonmail-desktop
      proton-vpn
      proton-pass
    ];
  };
}
