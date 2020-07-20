{ lib
, stdenv
, fetchFromGitHub
, gnumake
, xlibs
, instantUtils
}:
stdenv.mkDerivation {

  pname = "instantMenu";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantMENU";
    rev = "2fb01ab802a66bb9d1341ecac4b3b510d72953de";
    sha256 = "1p0rawh4bn9g2dy4g5gw51g7c6z4jw4s6yqywj9cjrp29xnsmkid";
  };

  nativeBuildInputs = [ gnumake ];
  buildInputs = with xlibs; map lib.getDev [ libX11 libXft libXinerama ];
  propagatedBuildInputs = [ instantUtils ];

  postPatch = ''
    substituteInPlace config.mk \
      --replace "PREFIX = /usr" "PREFIX = $out"
    patchShebangs theme.sh
  '';

  meta = with lib; {
    description = "Basic menu for instantOS";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantMENU";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
