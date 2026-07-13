{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  ripgrep,
  bubblewrap,
  versionCheckHook,
}:
let
  version = "0.144.3";

  # Map system to platform-specific npm package
  platformPkg =
    {
      x86_64-linux = {
        platform = "linux-x64";
        arch = "x86_64-unknown-linux-musl";
        hash = "sha256-RwPOiqsLpqzgKFdRHkVKhFNQOD8kIBbJrhT5QcN7Fmc=";
      };
      aarch64-linux = {
        platform = "linux-arm64";
        arch = "aarch64-unknown-linux-musl";
        hash = lib.fakeHash;
      };
      x86_64-darwin = {
        platform = "darwin-x64";
        arch = "x86_64-apple-darwin";
        hash = lib.fakeHash;
      };
      aarch64-darwin = {
        platform = "darwin-arm64";
        arch = "aarch64-apple-darwin";
        hash = "sha256-yFjLhFF49Xcsx7xBJzFytmk2TrdAKrhzio8vInphANk=";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "codex-cli: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "codex-cli";
  inherit version;

  src = fetchzip {
    url = "https://registry.npmjs.org/@openai/codex/-/codex-${version}-${platformPkg.platform}.tgz";
    hash = platformPkg.hash;
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    mkdir -p $out/lib/${finalAttrs.pname}

    # Copy vendor directory with the native binary and resources
    cp -r $src/vendor/${platformPkg.arch}/* $out/lib/${finalAttrs.pname}/

    # The main binary
    makeWrapper $out/lib/${finalAttrs.pname}/bin/codex $out/bin/codex \
      --prefix PATH : ${
        lib.makeBinPath ([ ripgrep ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ])
      }

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Lightweight coding agent from OpenAI that runs locally in your terminal";
    homepage = "https://github.com/openai/codex";
    changelog = "https://github.com/openai/codex/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "codex";
  };
})
