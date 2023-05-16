{ lib,
stdenv,
fetchFromGitHub,
fetchFromRepoOrCz,
fetchgit,
binaryen,
boehmgc,
enableLargeConfig ? false,
enableMmap ? true,
freetype,
glfw,
makeWrapper,
openssl,
sqlite,
tinycc,
upx,
xorg
}:

stdenv.mkDerivation rec {
  pname = "vlang";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "vlang";
    repo = "v";
    rev = "${version}";
    sha256 = "sha256-JENb+9mKixHWwVgj+RuH6OWns7murWc4zovEZ/YJCuc=";
  };

  # Required for bootstrap.
  vc = fetchFromGitHub {
    owner = "vlang";
    repo = "vc";
    rev = "6be6daffdbd8227595aea70cc981bf4c634decb7";
    sha256 = "sha256-j4qkGvnyTEC1BFFNXo++vIQvFNhSkxCOCEU7fvYPE7s=";
  };

  # Required for vdoc.
  markdown = fetchFromGitHub {
    owner = "vlang";
    repo = "markdown";
    rev = "6e970bd0a7459ad7798588f1ace4aa46c5e789a2";
    sha256 = "sha256-hFf7c8ZNMU1j7fgmDakuO7tBVr12Wq0dgQddJnkMajE=";
  };

  vlangtinycc = tinycc.overrideAttrs (finalAttrs: previousAttrs: {
    src = fetchFromRepoOrCz {
      repo = "tinycc";
      rev = "806b3f98";
      hash = "sha256-WQq3WsUlzVg2Nfb3FK6ibbvhsqJGe84zhj64EPH5tT4=";
    };

    configureFlags = [
      "--cc=$CC"
      "--ar=$AR"
      "--crtprefix=${lib.getLib stdenv.cc.libc}/lib"
      "--sysincludepaths=${lib.getDev stdenv.cc.libc}/include:{B}/include"
      "--libpaths=${lib.getLib stdenv.cc.libc}/lib"
      # build cross compilers
      "--enable-cross"

      # vlang tinycc flags
      "--extra-cflags=-O3"
      "--config-bcheck=yes"
      "--config-backtrace=yes"
      "--debug"
    ];
  });

  libgc = boehmgc.overrideAttrs (finalAttrs: previousAttrs: {
    configureFlags = [
      # Nixos configure flags
      "--enable-cplusplus"
      "--with-libatomic-ops=none"

      # vlang libgc build flags
      "--enable-threads=pthreads"
      "--enable-static"
      "--enable-thread-local-alloc=no"
      "--enable-parallel-mark"
      "--enable-single-obj-compilation"
      "--enable-gc-debug"
    ]
    ++ lib.optional enableMmap "--enable-mmap"
    ++ lib.optional enableLargeConfig "--enable-large-config";
  });

  vlangbinaryen = binaryen.overrideAttrs (finalAttrs: previousAttrs: {
    version = "112";
    src = fetchFromGitHub {
      owner = "WebAssembly";
      repo = "binaryen";
      rev = "version_${vlangbinaryen.version}";
      sha256 = "sha256-xVumVmiLMHJp3SItE8eL8OBPeq58HtOOiK9LL8SP4CQ=";
    };
    patches = [];
  });

  # The included vsh scripts with shebangs aren't critical for most development
  dontPatchShebangs = 1;

  propagatedBuildInputs = [ glfw freetype openssl sqlite ]
  ++ lib.optional stdenv.hostPlatform.isUnix upx;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ xorg.libX11 ];

  makeFlags = [
    "local=1"
    "VC=${vc}"
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
    mkdir -p thirdparty/tcc/lib
    ln -s ${vlangtinycc}/bin/tcc thirdparty/tcc/tcc.exe
    ln -s ${vlangtinycc}/lib/tcc/libtcc1.a thirdparty/tcc/lib/libtcc.a

    ln -s ${libgc}/lib/libgc.a thirdparty/tcc/lib/

    mkdir -p thirdparty/binaryen
    ln -s ${vlangbinaryen}/bin/ thirdparty/binaryen/bin
    ln -s ${vlangbinaryen}/lib/ thirdparty/binaryen/lib
    ln -s ${vlangbinaryen}/include/ thirdparty/binaryen/include
  '';

  # vcreate_test.v requires git, so we must remove it when building the tools.
  # vtest.v fails on Darwin, so let's just disable it for now.
  preInstall = ''
    mv cmd/tools/vcreate/vcreate_test.v $HOME/vcreate_test.v
  '' + lib.optionalString stdenv.isDarwin ''
    mv cmd/tools/vcreate/vtest.v $HOME/vtest.v
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,lib,share}
    cp -r examples $out/share
    cp -r {cmd,vlib,thirdparty} $out/bin
    cp v $out/bin
    mkdir -p $HOME/.vmodules;
    ln -sf ${markdown} $HOME/.vmodules/markdown
    $out/bin/v -v build-tools
    $out/bin/v -v $out/bin/cmd/tools/vcreate
    $out/bin/v -v $out/bin/cmd/tools/vdoc
    $out/bin/v -v $out/bin/cmd/tools/vast
    $out/bin/v -v $out/bin/cmd/tools/vvet
    runHook postInstall
  '';

  # Return vcreate_test.v and vtest.v, so the user can use it.
  postInstall = ''
    cp $HOME/vcreate_test.v $out/bin/cmd/tools/vcreate_test.v
  '' + lib.optionalString stdenv.isDarwin ''
    cp $HOME/vtest.v $out/bin/cmd/tools/vtest.v
  '';

  meta = with lib; {
    homepage = "https://vlang.io/";
    description = "Simple, fast, safe, compiled language for developing maintainable software";
    license = licenses.mit;
    #maintainers = with maintainers; [ Madouura ];
    mainProgram = "v";
    platforms = platforms.all;
  };
}
