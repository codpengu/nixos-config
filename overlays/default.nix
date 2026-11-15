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

  # Temporary workaround: telegram-desktop 7.4.1 fails on darwin because
  # swift-stdlib-tool can't find Swift lib dirs in the nixpkgs swift layout
  # ("Couldn't discover Swift library directories"). Same fix as upstream
  # commit bbc3d4fb1d ("telegram-desktop: fix build with swift").
  # Once nixos-unstable ships telegram-desktop >= 7.4.2, delete this whole
  # override and uncomment the pass-through below:
  # telegram-desktop = super.telegram-desktop;
  telegram-desktop =
    if super.stdenv.hostPlatform.isDarwin then
      super.telegram-desktop.override {
        unwrapped = super.telegram-desktop.unwrapped.overrideAttrs (o: {
          postPatch = (o.postPatch or "") + ''
            substituteInPlace Telegram/cmake/telegram_apple_swift_runtime.cmake \
              --replace-warn 'COMMAND "''${swift_bin_dir}/swift-stdlib-tool"' 'COMMAND true' \
              --replace-warn 'COMMAND xcrun swift-stdlib-tool' 'COMMAND true'
          '';
        });
      }
    else
      super.telegram-desktop;
}
