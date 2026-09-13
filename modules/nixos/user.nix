{ ... }:
{
  flake.modules.nixos.user = { pkgs, ... }: {
    users.users.mercury = {
      isNormalUser = true;
      description = "Hunter Welch";
      extraGroups = [ "networkmanager" "wheel" "video" "render" ];
      shell = pkgs.zsh;
      initialPassword = "chloe";
    };

    programs.zsh.enable = true;
  };
}
