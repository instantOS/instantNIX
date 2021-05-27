{ lib
, stdenv
, fetchFromGitHub
, sqlite
}:
stdenv.mkDerivation {

  pname = "instantShell";
  version = "unstable";

  srcs = [ 
    (fetchFromGitHub {
      owner = "instantOS";
      repo = "instantshell";
      rev = "30375cb4e2cb929c36eaf5c992ea3b6e59309125";
      sha256 = "74hCxsty3QGsuUtCHmDc6H31tuJL5E1pxXevZd/ETlI=";
      name = "instantOS_instantShell";
    })
    (fetchFromGitHub {
      owner = "ohmyzsh";
      repo = "ohmyzsh";
      rev = "7ab15bee033a1ce6791b05f4636221cba7b9505e";
      sha256 = "c/z5TGeVZQjROiDrwxZ5Ol0GIXTuEc2PJ//Po5Rinv4=";
      name = "ohmyzsh";
    })
  ];

  sourceRoot = ".";

  dontBuild = true;

  makeFlags = [ "PREFIX=$(out)" ];

  postPatch = ''
    ls -lh
    cat instantOS_instantShell/zshrc >> ohmyzsh/templates/zshrc.zsh-template
    rm instantOS_instantShell/zshrc
  '';

  installPhase = ''
    install -Dm 755 instantOS_instantShell/instantshell.sh "$out/bin/instantshell"
    install -Dm 644 instantOS_instantShell/instantos.plugin.zsh $out/share/instantshell/custom/plugins/instantos/instantos.plugin.zsh
    install -Dm 644 instantOS_instantShell/instantos.zsh-theme $out/share/instantshell/custom/themes/instantos.zsh-theme
    install -Dm 644 instantOS_instantShell/zshrc $out/share/instantshell/zshrc || true
    cp -r ohmyzsh/* $out/share/instantshell
  '';

  meta = with lib; {
    description = "instantOS Shell";
    license = licenses.mit;
    homepage = "https://github.com/instantOS/instantshell";
    maintainers = [ "Scott Hamilton <sgn.hamilton+nixpkgs@protonmail.com>" ];
    platforms = platforms.linux;
  };
}
