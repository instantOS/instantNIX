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
      rev = "517cae5636f23dee691b799dd56d11bfd2acc573";
      sha256 = "1yqsy588fjqj07yill34w1mmcr6xjwhdmx6miv0mv0lwp8vxj2cx";
      name = "instantOS_instantWallpaper";
    }) 
    (fetchFromGitHub {
      owner = "instantOS";
      repo = "instantLOGO";
      rev = "d0fd92af26138d6f2451787726b478b18f544ff3";
      sha256 = "0x93yfri7wm2bw8bd83hj9zzk3q5yj3s35pix6rq7zcgcsbf94jr";
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
  '';

  installPhase = ''
    install -Dm 555 wallutils.sh "$out/share/instantwallpaper/wallutils.sh"
    install -Dm 555 wall.sh "$out/bin/instantwallpaper"
    install -Dm 644 ../instantOS_instantLogo/wallpaper/defaultwall.png "$out/share/backgrounds/instant.png"
    install -Dm 644 ../instantOS_instantLogo/wallpaper/readme.jpg "$out/share/backgrounds/readme.jpg"
    install -Dm 644 ../instantOS_instantLogo/ascii.txt "$out/share/instantwallpaper/ascii.txt"
    install -Dm 644 ../instantOS_instantLogo/wallpaper/defaultphoto.png "$out/share/instantwallpaper/defaultphoto.png"
  '';

  postInstall = ''
    wrapProgram "$out/bin/instantwallpaper" \
      --prefix PATH : ${lib.makeBinPath [ instantConf instantUtils nitrogen ]}
    wrapProgram "$out/share/instantwallpaper/wallutils.sh" \
      --prefix PATH : ${lib.makeBinPath [ instantConf instantUtils imagemagick ]}
  '';

  meta = with lib; {
    description = "Wallpaper manager of instantOS";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantWM";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
