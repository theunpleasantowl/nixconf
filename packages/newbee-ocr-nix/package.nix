{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "newbee-ocr-cli";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "zibo-chen";
    repo = "newbee-ocr-cli";
    rev = "v${version}";
    hash = "sha256-I4fT36ATshg6Zy+a8m+hypqknNf5x4cLiU/k/7GfHsA=";
  };

  patches = [
    ./japanese-ppocrv5-alias.patch
    ./recognize-fast-precision-default.patch
  ];

  cargoHash = "sha256-cw/kG8uEbGHrRFJDE1n4gxNkaEd6tam8vrVzbkw+zNc=";

  mnnSrc = fetchFromGitHub {
    owner = "alibaba";
    repo = "MNN";
    rev = "029a0fbb2ed6f29133b3852629daeb7cfffc29dc";
    hash = "sha256-B8/Wbhpj8UnkF//SkcRLUqok8yFidpTPkRzE6cxbxec=";
  };

  nativeBuildInputs = [
    cmake
    rustPlatform.bindgenHook
  ];

  env.MNN_SOURCE_DIR = mnnSrc;

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "embed-det-v5"
    "embed-rec-chinese"
    "embed-rec-english"
  ];

  doCheck = false;

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/nbocr --version | grep -F "${version}"
    $out/bin/nbocr list >/dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "CLI tool for OCR based on ocr-rs";
    homepage = "https://github.com/zibo-chen/newbee-ocr-cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "nbocr";
  };
}
