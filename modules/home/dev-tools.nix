{ ... }:
{
  flake.modules.homeManager.dev-tools = { pkgs, ... }: {
    home.packages = with pkgs; [
      # Rust (toolchain via rustup; rust-analyzer itself lives in Zed's
      # extraPackages to avoid colliding with rustup's bundled copy)
      rustup
      gcc

      # Python
      python3

      # Claude Code + GitHub CLI auth companion
      claude-code

      # CLI utils
      eza
      bat
      ripgrep
      fd
      fzf
    ];
  };
}
