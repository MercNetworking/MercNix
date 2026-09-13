{ ... }:
{
  flake.modules.homeManager.shell = { config, ... }: {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [ "git" "sudo" "docker" "history-substring-search" ];
      };

      shellAliases = {
        ll = "ls -l";
        la = "ls -la";
        update = "sudo nixos-rebuild switch --flake .#$(hostname)";
        upgrade = "nix flake update && sudo nixos-rebuild switch --flake .#$(hostname)";
        garbage = "nix-collect-garbage -d";
        gs = "git status";
        ga = "git add .";
        gc = "git commit -m";
        gp = "git push";
        gpl = "git pull";
        cat = "bat";
        find = "fd";
        ls = "eza --icons";
        zed = "zeditor";
      };

      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };
    };

    programs.starship = {
      enable = true;
      settings = {
        add_newline = false;
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
  };
}
