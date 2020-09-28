{ lib
, stdenv
, fetchFromGitHub
, gnumake
, xlibs
}:
stdenv.mkDerivation {

  pname = "instantLogo";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantLOGO";
    rev = "4d9485c4e2ffe2c7f8b73bdfa1a3bc1a548e48e2";
    sha256 = "0hvk5y0r46ykvmj93qnks4pvmgf2a9g8p6dq1wlyf71g0y5yg6m0";
    name = "instantOS_instantLogo";
  };

  installPhase = ''
    install -Dm 644 wallpaper/readme.jpg $out/share/backgrounds/readme.jpg
  '';

  meta = with lib; {
    description = "Logo assets of instantOS.";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantWM";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
