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

  version = "3.12.59";
  vscodeVersion = "1.141.2";
  pname = "windsurf";

  executableName = "windsurf";
  sourceExecutableName = "devin-desktop";
  longName = "Devin";
  shortName = "devin-desktop";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/0122b42e158c7ca62960222fb9725f087cd9544f/Devin-linux-x64-3.12.59.tar.gz";
    sha256 = "sha256-CnRWCBjZWHw7V8PnvGc6vPQn+cw000r3I0n2Fh6VJRQ=";
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
