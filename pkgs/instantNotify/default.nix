{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, instantMenu
, sqlite
}:
stdenv.mkDerivation {

  pname = "instantNotify";
  version = "unstable";

  src = fetchFromGitHub {
    owner = "instantOS";
    repo = "instantNOTIFY";
    rev = "04fe0053d3e9895504e02a4f555d1bd4b7f79462";
    sha256 = "euZg/SmvICP4mFDazK4izE0OB43bzFHGxcP2K8eyYzw=";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ instantMenu sqlite ];

  postPatch = ''
    substituteInPlace install.sh \
      --replace "/usr" "$out" \
      --replace "sudo " ""
    patchShebangs *.sh
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    ./install.sh
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/instantnotifyctl" \
      --prefix PATH : ${lib.makeBinPath [ sqlite ]}
  '';

  meta = with lib; {
    description = "Notification system for instantOS";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantNOTIFY";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
