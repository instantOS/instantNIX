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
    rev = "f58948b937d33bf7f00571f19ab160c0b54a2b4b";
    sha256 = "14mphz1vmdyjkjxp7j8ybbjrrs4rri7yca08xy8441hgn96bwiw7";
    name = "instantOS_instantMenu";
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
