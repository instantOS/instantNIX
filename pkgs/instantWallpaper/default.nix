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
      rev = "17e5901a8713f3586569b49e2834901958784d8e";
      sha256 = "174ww7c5hin8x0nignqywah742h6q2540ryh3hqx6rhs88p6c2l3";
      name = "instantOS_instantWallpaper";
    }) 
    (fetchFromGitHub {
      owner = "instantOS";
      repo = "instantLOGO";
      rev = "eae11e5ecbcec19c9a2a88f463a7c2741faf8de6";
      sha256 = "14xzam17pgwifx9jlwicfxj6rpg779fy2p5p24j42nkm8ipmwpkm";
      name = "instantOS_instantLogo";
    })
  ];

  sourceRoot = "instantOS_instantWallpaper";

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
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantWM";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
