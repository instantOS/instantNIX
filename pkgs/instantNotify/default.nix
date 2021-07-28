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
    rev = "196e05d296e645add9cda55af180ceafeb77ce03";
    sha256 = "R6vkIRsYhre+s5tfP0oIH16AnfDM890ectZAKjjGQPY=";
  };

  nativeBuildInputs = [ makeWrapper ];
  propagatedBuildInputs = [ instantMenu sqlite ];

  makeFlags = [ "DESTDIR=$(out)/" "PREFIX=" ];

  postPatch = ''
    patchShebangs *.sh
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    make install DESTDIR=$out/ PREFIX=
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
