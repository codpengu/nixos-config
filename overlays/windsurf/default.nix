{
  lib,
  stdenv,
  pkgs,
  buildVscode,
  fetchurl,
  nixosTests,
  commandLineArgs ? "",
}:
# https://windsurf-stable.codeium.com/api/update/linux-x64/stable/latest
# https://windsurf-next.codeium.com/api/update/linux-x64/stable/latest
(buildVscode {
  inherit commandLineArgs;
  useVSCodeRipgrep = false;

  version = "3.10.35";
  vscodeVersion = "1.126.0";
  pname = "windsurf";

  executableName = "windsurf";
  sourceExecutableName = "devin-desktop";
  longName = "Devin";
  shortName = "devin-desktop";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/dfa4a2d639b8a05ab72387c12f1aafca1b4c3cb9/Devin-linux-x64-3.10.35.tar.gz";
    sha256 = "sha256-/VDrVIpqle+n3yToUnP50kZCRzUN53dR2CXzVWqCbsY=";
    # sha256 = lib.fakeSha256;
  };

  sourceRoot = "Devin";

  tests = nixosTests.vscodium;

  updateScript = "nil";

  meta = with lib; {
    description = "The first agentic IDE, and then some";
  };
}).overrideAttrs
  (oldAttrs: {
    postInstall = (oldAttrs.postInstall or "") + ''
      if [ -e "$out/lib/vscode/devin-desktop" ] && [ ! -e "$out/lib/vscode/windsurf" ]; then
        ln -s devin-desktop "$out/lib/vscode/windsurf"
      fi
    '';
  })
