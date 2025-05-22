{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, gtk3
, gdk-pixbuf
, withWayland ? true
, gtk-layer-shell
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "eww";
  version = "latest";

  src = fetchFromGitHub {
    owner = "elkowar";
    repo = pname;
    rev = "dc3129a";
    sha256 = "sha256-YUuH1BZ3G5dhHRZ1Z9XPXyorm8vV8G+jYbcdIGxOcOs=";
  };

  cargoSha256 = "sha256-cU9+4tjPSY1ypqczWG/i/7Ek5vtkVDol86yo/gVyxIU=";

  # cargoPatches = [ ./Cargo.lock.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 gdk-pixbuf ] ++ lib.optional withWayland gtk-layer-shell;

  buildNoDefaultFeatures = withWayland;
  buildFeatures = lib.optional withWayland "wayland";

  cargoBuildFlags = [ "--bin" "eww" ];

  cargoTestFlags = cargoBuildFlags;

  # requires unstable rust features
  RUSTC_BOOTSTRAP = 1;

  meta = with lib; {
    description = "ElKowars wacky widgets";
    homepage = "https://github.com/elkowar/eww";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda lom ];
    broken = stdenv.isDarwin;
  };
}
