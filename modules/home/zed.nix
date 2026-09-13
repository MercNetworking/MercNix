# Zed is the primary editor, configured entirely via home-manager for
# portability across hosts.
#
# Nix and QML aren't built into Zed core, so they need extensions
# (`extensions = [ "nix" "qml" ]` below); Rust, Python, and C++ are
# built-in and just need their LSP binary discoverable on PATH, which
# `extraPackages` provides.
#
# LSP coverage:
#   - nix              -> nixd, nil (zed-extensions/nix; server id is "nixd",
#                          not "nix" — see the `lsp` block below)
#   - rust             -> rust-analyzer (kept out of home.packages/dev-tools
#                          — it collides with rustup's bundled copy in the
#                          same profile, so it's isolated here in Zed's own
#                          extraPackages instead)
#   - python           -> pyright, ruff
#   - Noctalia (QML/Quickshell) -> the "qml" extension, which bundles its
#                          own language server; qt6.qtdeclarative's qmlls is
#                          kept as a fallback in case it expects one on PATH
#   - Umbriel (C++23)  -> clangd, via clang-tools
#
# Zed moves fast — if something here has drifted, check
# https://zed.dev/extensions/nix and https://zed.dev/extensions/qml first.
{ ... }:
{
  flake.modules.homeManager.zed = { pkgs, ... }: {
    programs.zed-editor = {
      enable = true;

      extensions = [ "nix" "qml" ];

      extraPackages = with pkgs; [
        nixd
        nil
        rust-analyzer
        pyright
        ruff
        clang-tools
        qt6.qtdeclarative
      ];

      userSettings = {
        lsp = {
          nixd = {
            binary.path = "${pkgs.nixd}/bin/nixd";
          };
        };

        languages = {
          Nix.language_servers = [ "nixd" "!nil" ];
        };
      };
    };
  };
}
