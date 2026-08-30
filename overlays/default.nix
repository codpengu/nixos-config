{ inputs, pkgs }:
_self: super: {
  jdt-ls = super.callPackage ./jdt-ls { };
  kotlin-lsp = super.callPackage ./kotlin-lsp { };
  rofi-collection = super.callPackage ./rofi-collection { };
  npm-groovy-lint = super.callPackage ./npm-groovy-lint { };
  ghostty = inputs.ghostty.packages.${super.stdenv.hostPlatform.system}.default;
  windsurf =
    if super.stdenv.hostPlatform.isLinux then super.callPackage ./windsurf { } else super.devin-desktop;
  cursor = super.callPackage ./cursor { };
  claude-code =
    if super.stdenv.hostPlatform.isLinux then
      super.callPackage ./claude-code { }
    else
      super.claude-code;
  codex-cli = super.callPackage ./codex-cli { };
  copilot-cli = super.callPackage ./copilot-cli { };
  antigravity = super.callPackage ./antigravity { };
  orion-browser = super.callPackage ./orion-browser { };
  rtk = super.callPackage ./rtk { };
  ccusage = inputs.ccusage.packages.${super.stdenv.hostPlatform.system}.default;
  opencode = super.callPackage ./opencode { };
}
