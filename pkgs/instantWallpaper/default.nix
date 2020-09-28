{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, instantLogo
, instantConf
, instantUtils
, Paperbash
, imagemagick
, nitrogen
}:
stdenv.mkDerivation {

  pname = "instantWallpaper";
  version = "unstable";

  srcs = [
    (fetchFromGitHub {
      owner = "instantOS";
      repo = "instantWALLPAPER";
      rev = "b2d76ecf683dfbe387e9692e3055c73a615ff223";
      sha256 = "0i7zm02m44c3qgnjisp0xn6v10yyw2zzvzw28ay355kdzpc8s7dr";
      name = "instantOS_instantWallpaper";
    }) 
    (fetchFromGitHub {
      owner = "instantOS";
      repo = "instantLOGO";
      rev = "4d9485c4e2ffe2c7f8b73bdfa1a3bc1a548e48e2";
      sha256 = "0hvk5y0r46ykvmj93qnks4pvmgf2a9g8p6dq1wlyf71g0y5yg6m0";
      name = "instantOS_instantLogo";
    })
  ];

  sourceRoot = "instantOS_instantWallpaper";

  patches = [ ./set-instantix-overlay.patch ];

  nativeBuildInputs = [ makeWrapper ];

  propagatedBuildInputs = [
    instantConf
    instantLogo
    instantUtils
    Paperbash
    imagemagick
    nitrogen
  ];

  postPatch = ''
    substituteInPlace wall.sh \
      --replace /usr/share/backgrounds/readme.jpg ${instantLogo}/share/backgrounds/readme.jpg \
      --replace /usr/share/instantwallpaper/wallutils.sh wallutils.sh \
      --replace "/usr/share/paperbash" "${Paperbash}/share/paperbash" \
      --replace wallutils.sh "$out/share/instantwallpaper/wallutils.sh"
    patchShebangs *.sh
  '';

  installPhase = ''
    install -Dm 555 wallutils.sh "$out/share/instantwallpaper/wallutils.sh"
    install -Dm 555 wall.sh "$out/bin/instantwallpaper"
    install -Dm 644 ../instantOS_instantLogo/wallpaper/defaultwall.png "$out/share/backgrounds/instant.png"
    install -Dm 644 ../instantOS_instantLogo/wallpaper/readme.jpg "$out/share/backgrounds/readme.jpg"
    install -Dm 644 ../instantOS_instantLogo/ascii.txt "$out/share/instantwallpaper/ascii.txt"
    install -Dm 644 ../instantOS_instantLogo/wallpaper/defaultphoto.png "$out/share/instantwallpaper/defaultphoto.png"
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram "$out/bin/instantwallpaper" \
      --prefix PATH : ${lib.makeBinPath [ instantConf instantUtils nitrogen ]}
    # wrapProgram "$out/share/instantwallpaper/wallutils.sh" \
    #   --prefix PATH : ${lib.makeBinPath [ instantConf instantUtils imagemagick ]}
    #   --prefix PATH : ${lib.makeBinPath [ instantConf instantUtils imagemagick ]}
    sed -i '2s|^|export\ PATH="${lib.makeBinPath [ instantConf instantUtils imagemagick ]}"\$\{PATH:\+\":\"\}\$PATH|' "$out/share/instantwallpaper/wallutils.sh" 
  '';

  meta = with lib; {
    description = "Wallpaper manager of instantOS";
    license = licenses.gpl2;
    homepage = "https://github.com/instantOS/instantWM";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
