{ lib
, stdenv
, fetchFromGitHub
, gnumake
, xlibs
, instantAssist
}:
stdenv.mkDerivation {

  pname = "islide";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "islide";
    rev = "28b76a0c9dae1c157bd6acb78d331ad3113bc2f2";
    sha256 = "1d322719806fky6fsyj0japsrywwpq0kywh8mlnv3878pbngw393";
    name = "instantOS_islide";
  };

  postPatch = ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr/" "PREFIX = $out"
    substituteInPlace islide.c \
      --replace /usr/share/instantassist/assists "${instantAssist}/share/instantassist/assists" \
  '';

  nativeBuildInputs = [ gnumake ];
  buildInputs = with xlibs; map lib.getDev [ libX11 libXft libXinerama ];

  propagatedBuildInputs = [ instantAssist ];

  meta = with lib; {
    description = "instantOS Slide";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/islide";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
