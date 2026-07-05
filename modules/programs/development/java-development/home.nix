{ lib, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) isDarwin isLinux;

  additionalJDKs = with pkgs; [
    openjdk11
    zulu11
  ];
in
{
  home.sessionPath = [ "$HOME/.jdks" ];
  home.file = (
    builtins.listToAttrs (
      builtins.map (jdk: {
        name = ".jdks/${jdk.pname}-${jdk.version}";
        value = {
          source = jdk;
        };
      }) additionalJDKs
    )
  );

  home.packages =
    with pkgs;
    [
      jetbrains.idea
      jetbrains.datagrip
      gh
      git-ignore
      kotlin-lsp
      ktlint
    ]
    ++ lib.optionals isDarwin [
      claude-code
      codex-cli
      ccusage
      rtk
      copilot-cli
      openspec
      vscode
      zed-editor
      windsurf
    ]
    ++ lib.optionals isLinux [
      # jetbrains.webstorm
      windsurf.fhs
      # antigravity
      # cursor
      claude-code
      codex-cli
      ccusage
      rtk
      copilot-cli
      openspec
      # jetbrains.idea-community
      vscode.fhs
      zed-editor-fhs
      # gitbutler
    ];
}
