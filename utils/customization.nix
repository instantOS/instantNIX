#{ pkgs ? import <nixpkgs> {}}:
#let
#  default = import ./default.nix { pkgs=pkgs; }; # defaultTerminal=pkgs.kitty; };
#in
#default

(import ./. { pkgs=import <nixpkgs> {}; }).extend (self: super: {
  instantwm = (super.instantwm.override {
    defaultTerminal = self.pkgs.kitty;
    wmconfig = ./customconfig.h;  
  });
})

#  .overrideAttrs (oldAttrs: {
#    # required for the current dwm config patch
#    propagatedBuildInputs = [
#      self.dmenu
#      self.xterm
#      self.jq
#      self.firefox
#      self.autorandr
#      # alsaUtils
#      # systemd
#      # redshift
#    ];
#  });
#}

