{
  lib,
  stdenv,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  fetchPnpmDeps,
  imagemagick,
  makeBinaryWrapper,
  makeDesktopItem,
  nodejs,
  pkg-config,
  pnpm_11,
  pnpmConfigHook,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

let
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "wfhelper";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "WFHelper";
    repo = "WFHelper";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h7xlGJ7LruXpLZ1khxgAaiJBJUMxQkie737ZSjGy4To=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-6T0eHyoZSC+l5svlJYspxg74rtoQs1sdg18go8Qbgv8=";
  };

  # package.json in the repository is a dev placeholder; the release version
  # comes from the git tag. Set it before installing, like their release
  # workflow does, so it is baked into the renderer bundle.
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'
  '';

  # The Electron binary is provided by nixpkgs, never downloaded.
  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  strictDeps = true;

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook
    makeBinaryWrapper
    copyDesktopItems
    imagemagick
    # native/layer-shell addon
    pkg-config
    wayland-scanner
  ];
  # Libraries for the layer-shell addon; also provides the .pc files
  # pkg-config needs under strictDeps.
  buildInputs = [
    wayland
    wayland-protocols
  ];

  # Mirrors the release workflow: build, compile the layer-shell addon,
  # verify the OCR models, then package. --dir instead of AppImage: we
  # wrap nixpkgs' Electron directly instead of the bundled one.
  buildPhase = ''
    runHook preBuild

    pnpm run verify:onnx-models
    pnpm run build
    node scripts/build-layer-shell.mjs --require

    pnpm exec electron-builder --dir --publish never \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/wfhelper
    cp -r release/linux-unpacked/resources/. $out/share/wfhelper/

    makeBinaryWrapper ${lib.getExe electron} $out/bin/wfhelper \
      --add-flags $out/share/wfhelper/app.asar \
      --inherit-argv0

    for size in 16 32 48 64 128 256 512; do
      mkdir -p "$out/share/icons/hicolor/$size"x"$size/apps"
      magick assets/logo.png -resize "$size"x"$size" \
        "$out/share/icons/hicolor/$size"x"$size/apps/wfhelper.png"
    done

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "wfhelper";
      desktopName = "WFHelper";
      comment = "Warframe companion: inventory, foundry, relic and riven scanning, market orders.";
      exec = "wfhelper %U";
      icon = "wfhelper";
      categories = [ "Utility" ];
      startupWMClass = "wfhelper";
      terminal = false;
    })
  ];

  meta = {
    description = "Unofficial Warframe companion app for Windows and Linux";
    homepage = "https://wfhelper.com";
    changelog = "https://github.com/WFHelper/WFHelper/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "wfhelper";
    platforms = [ "x86_64-linux" ];
    # npm dependencies ship prebuilt native code (sharp, onnxruntime, koffi).
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
