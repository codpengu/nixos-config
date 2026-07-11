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

  version = "3.4.27";
  vscodeVersion = "1.110.1";
  pname = "windsurf";

  executableName = "windsurf";
  sourceExecutableName = "devin-desktop";
  longName = "Devin";
  shortName = "devin-desktop";

  src = fetchurl {
    url = "https://windsurf-stable.codeiumdata.com/linux-x64/stable/0d4bf12ed4a7597cb8ae9016fe8474468aad98a2/Devin-linux-x64-3.4.27.tar.gz";
    sha256 = "sha256-gIUBJLMTMfY8JKIB0TF72s37Q4+yvMmzHJt6Y5E5Fhk=";
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
