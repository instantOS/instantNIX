{ lib
, stdenv
, fetchFromGitHub
, instantAssist
, instantConf
, instantDotfiles
, instantLogo
, instantMenu
, instantShell
, instantThemes
, instantUtils
, instantWallpaper
, instantWidgets
, instantWm
, Paperbash
, rangerplugins
}:
stdenv.mkDerivation {

  pname = "instantData";
  version = "unstable";

  src = fetchFromGitHub {
    # owner = "SCOTT-HAMILTON";
    owner = "ppenguin";
    repo = "instantData";
    # rev = "ade1148cd26c272cb569f9a4c10337f5a4e91f29";
    ref = "add-user-config-capability";
    rev = "bba7c8e13eec3791aa65e7bbc41c69928a26d842";
    sha256 = "sha256:06x6fy1al20m37sa32i6kxczjws39zfg1xrwa4n0vfyrq1mj734l";
    name = "instantOS_instantData";
  };

  propagatedBuildInputs = [
    instantDotfiles
    instantLogo
    instantMenu
    instantShell
    instantThemes
    instantUtils
    instantWallpaper
    instantWidgets
    instantWm
    Paperbash
    rangerplugins
  ];

  postPatch = ''
    substituteInPlace instantdata.sh \
      --subst-var-by instantASSIST "${instantAssist}" \
      --subst-var-by instantConf "${instantConf}" \
      --subst-var-by instantDotfiles "${instantDotfiles}" \
      --subst-var-by instantLOGO "${instantLogo}" \
      --subst-var-by instantMENU "${instantMenu}" \
      --subst-var-by instantShell "${instantShell}" \
      --subst-var-by instantTHEMES "${instantThemes}" \
      --subst-var-by instantUtils "${instantUtils}" \
      --subst-var-by instantWALLPAPER "${instantWallpaper}" \
      --subst-var-by instantWidgets "${instantWidgets}" \
      --subst-var-by instantWM "${instantWm}" \
      --subst-var-by Paperbash "${Paperbash}" \
      --subst-var-by rangerplugins "${rangerplugins}"
  '';

  installPhase = ''
    install -Dm 555 instantdata.sh $out/bin/instantdata
    # install -Dm 644 desktop/st-luke.desktop $out/share/applications/st-luke.desktop
  '';

  meta = with lib; {
    description = "instantOS Data";
    license = licenses.mit;
    homepage = "https://github.com/SCOTT-HAMILTON/InstantData";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
