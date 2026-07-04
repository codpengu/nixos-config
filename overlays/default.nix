{ inputs, pkgs }:
_self: super: {
  jdt-ls = super.callPackage ./jdt-ls { };
  kotlin-lsp = super.callPackage ./kotlin-lsp { };
  rofi-collection = super.callPackage ./rofi-collection { };
  npm-groovy-lint = super.callPackage ./npm-groovy-lint { };
  ghostty = inputs.ghostty.packages.${super.stdenv.hostPlatform.system}.default;
  windsurf =
    if super.stdenv.hostPlatform.isLinux then super.callPackage ./windsurf { } else super.windsurf;
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
  opencode =
    let
      # --- WORKAROUND: opencode often bumps its packageManager Bun version before
      # nixpkgs has that exact Bun release. Allow the fixed-output node_modules
      # build to refresh bun.lock metadata in the temporary build tree; outputHash
      # still pins the installed node_modules result.
      #
      # SIMPLE (restore when upstream is fixed):
      # base = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      #
      # WORKAROUND (comment out when upstream is fixed):
      src = inputs.opencode.sourceInfo;
      rev = inputs.opencode.sourceInfo.shortRev or inputs.opencode.sourceInfo.dirtyShortRev or "dirty";
      node_modules =
        (super.callPackage "${src}/nix/node_modules.nix" {
          inherit rev;
          hash =
            if super.stdenv.hostPlatform.isDarwin then
              "sha256-7+4skFiJ+tLSjNG6WR53bT/IektA5B7gEcWLYpkK4z8="
            else
              "sha256-Ulflihjr8JDRVyNxSchoqaey6z/12256zs1FOiw+4vo=";
        }).overrideAttrs
          (oldAttrs: {
            buildPhase = builtins.replaceStrings [ "--frozen-lockfile" ] [ "" ] oldAttrs.buildPhase;
          });
      base = super.callPackage "${src}/nix/opencode.nix" { inherit node_modules; };
      # END WORKAROUND
      # base = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    base.overrideAttrs (oldAttrs: {
      preBuild = (oldAttrs.preBuild or "") + ''
        substituteInPlace packages/opencode/src/cli/cmd/generate.ts \
          --replace-fail 'const prettier = await import("prettier")' 'const prettier: any = { format: async (s: string) => s }' \
          --replace-fail 'const babel = await import("prettier/plugins/babel")' 'const babel = {}' \
          --replace-fail 'const estree = await import("prettier/plugins/estree")' 'const estree = {}'
      '';
      postPatch = (oldAttrs.postPatch or "") + ''
        substituteInPlace packages/script/src/index.ts \
          --replace-fail \
          'if (!semver.satisfies(process.versions.bun, expectedBunVersionRange)) {' \
          'if (false) {'
        mkdir -p .github
        touch .github/TEAM_MEMBERS
      '';
      buildPhase = ''
        runHook preBuild

        cd ./packages/opencode
        bun --bun ./script/build.ts --single --skip-install --skip-embed-web-ui
        bun --bun ./script/schema.ts schema.json

        runHook postBuild
      '';
    });
}
