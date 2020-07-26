{ lib
, stdenv
, fetchFromGitHub
, instantMenu
}:
stdenv.mkDerivation {

  pname = "instantNotify";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantNOTIFY";
    rev = "master";
    sha256 = "1fhh5p5g0dd6fpr2fj5bi7bkkbcdxnydgll2x1xfwrlqpd9nb3bk";
    name = "instantOS_instantNotify";
  };

  #nativeBuildInputs = [ gnumake ];
  #buildInputs = with xlibs; map lib.getDev [ libX11 libXft libXinerama ];
  propagatedBuildInputs = [ instantMenu ];

  postPatch = ''
    substituteInPlace install.sh \
      --replace "/usr" "$out" \
      --replace "sudo " ""
    patchShebangs *.sh
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    ./install.sh
  '';

  meta = with lib; {
    description = "Notification system for instantOS";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantNOTIFY";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
