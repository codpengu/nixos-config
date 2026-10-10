{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  cacert,
  patchelf,
  ripgrep,
  sysctl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  version = "1.18.35";

  platformPkg =
    {
      x86_64-linux = {
        package = "opencode-linux-x64";
        hash = "sha256-5ciZfV0AJNloaoSfINRidm2DZG502XUd+xcnFfIhYTM=";
      };
      aarch64-linux = {
        package = "opencode-linux-arm64";
        hash = "sha256-V/1uz+p5J8edOUN2bbOe+SZ/OL2zK6vms9jeofIUhLo=";
      };
      x86_64-darwin = {
        package = "opencode-darwin-x64";
        hash = "sha256-ui17Evyxb2h+O1IIqmeogtFwZfTNPwDfYP3E+xIj/9s=";
      };
      aarch64-darwin = {
        package = "opencode-darwin-arm64";
        hash = "sha256-tiZUP0Qny9ell1bCQEX28y28TPc0erWoYT9cn9aw7rM=";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "opencode: unsupported system ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode";
  inherit version;

  src = fetchurl {
    url = "https://registry.npmjs.org/${platformPkg.package}/-/${platformPkg.package}-${finalAttrs.version}.tgz";
    hash = platformPkg.hash;
  };

  sourceRoot = "package";

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    patchelf
  ];

  dontBuild = true;
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/${finalAttrs.pname}
    cp -r . $out/lib/${finalAttrs.pname}
    chmod +x $out/lib/${finalAttrs.pname}/bin/opencode

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        $out/lib/${finalAttrs.pname}/bin/opencode
    ''}

    mkdir -p $out/bin
    makeWrapper $out/lib/${finalAttrs.pname}/bin/opencode $out/bin/opencode \
      --set OPENCODE_DISABLE_AUTOUPDATE true \
      --set SSL_CERT_DIR "${cacert}/etc/ssl/certs" \
      --prefix PATH : ${
        lib.makeBinPath (
          [ ripgrep ]
          ++ lib.optionals stdenv.hostPlatform.isDarwin [
            sysctl
          ]
        )
      }${lib.optionalString stdenv.hostPlatform.isLinux " \\\n      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ stdenv.cc.cc.lib ]}"}

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = [ "--version" ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "AI coding agent built for the terminal";
    homepage = "https://opencode.ai";
    downloadPage = "https://www.npmjs.com/package/opencode-ai";
    changelog = "https://github.com/anomalyco/opencode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "opencode";
  };
})
