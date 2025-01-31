{ boost
, cairo
, cmake
, cups
, fetchurl
, fetchpatch
, fontconfig
, freetype
, harfbuzzFull
, hunspell
, lcms2
, libjpeg
, libtiff
, libxml2
, mkDerivation
, pixman
, pkg-config
, podofo
, poppler
, poppler_data
, python3
, qtbase
, qtimageformats
, qttools
, lib
}:

let
  pythonEnv = python3.withPackages (
    ps: [
      ps.pillow
      ps.tkinter
    ]
  );
in
mkDerivation rec {
  pname = "scribus";

  version = "1.5.7";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-devel/${pname}-${version}.tar.xz";
    sha256 = "sha256-MYMWss/Hp2GR0+DT+MImUUfa6gVwFiAo4kPCktgm+M4=";
  };

  patches = [
    # For harfbuzz >= 2.9.0
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/1b546978bc4ea0b2a73fbe4d7cf947887e865162.patch";
      sha256 = "sha256-noRCaN63ZYFfXmAluEYXdFPNOk3s5W3KBAsLU1Syxv4=";
    })
    # For harfbuzz >= 3.0
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/68ec41169eaceea4a6e1d6f359762a191c7e61d5.patch";
      sha256 = "sha256-xhp65qVvaof0md1jb3XHZw7uFX1RtNxPfUOaVnvZV1Y=";
    })
    # For Poppler 22.02
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/85c0dff3422fa3c26fbc2e8d8561f597ec24bd92.patch";
      sha256 = "YR0ii09EVU8Qazz6b8KAIWsUMTwPIwO8JuQPymAWKdw=";
    })
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/f75c1613db67f4067643d0218a2db3235e42ec9f.patch";
      sha256 = "vJU8HsKHE3oXlhcXQk9uCYINPYVPF5IGmrWYFQ6Py5c=";
    })
    # For Poppler 22.03
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/553d1fd5f76ffb3743583b88c78a7232b076a965.patch";
      sha256 = "56JrEG3eCzyALTH04yjzurKRj2PocpjO6b4PusMRxjY=";
    })
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/1f82e38be0782b065910f5fb4cece23f690349ae.patch";
      sha256 = "qektUfel5KeA327D3THyqi8dznP1SQQFToUC5Kd0+W4=";
    })
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/f19410ac3b27e33dd62105746784e61e85b90a1d.patch";
      sha256 = "JHdgntYcioYatPeqpmym3c9dORahj0CinGOzbGtA4ds=";
    })
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/e013e8126d2100e8e56dea5b836ad43275429389.patch";
      sha256 = "+siPNtJq9Is9V2PgADeQJB+b4lkl5g8uk6zKBu10Jqw=";
    })
    (fetchpatch {
      url = "https://github.com/scribusproject/scribus/commit/48263954a7dee0be815b00f417ae365ab26cdd85.patch";
      sha256 = "1WE9kALFw79bQH88NUafXaZ1Y/vJEKTIWxlk5c+opsQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    cairo
    cups
    fontconfig
    freetype
    harfbuzzFull
    hunspell
    lcms2
    libjpeg
    libtiff
    libxml2
    pixman
    podofo
    poppler
    poppler_data
    pythonEnv
    qtbase
    qtimageformats
    qttools
  ];

  cmakeFlags = [
    # poppler uses std::optional
    "-DWANT_CPP17=ON"
  ];

  meta = with lib; {
    maintainers = with maintainers; [
      erictapen
      kiwi
    ];
    platforms = platforms.linux;
    description = "Desktop Publishing (DTP) and Layout program for Linux";
    homepage = "https://www.scribus.net";
    # There are a lot of licenses...
    # https://github.com/scribusproject/scribus/blob/20508d69ca4fc7030477db8dee79fd1e012b52d2/COPYING#L15-L19
    license = with licenses; [
      bsd3
      gpl2Plus
      mit
      publicDomain
    ];
  };
}
