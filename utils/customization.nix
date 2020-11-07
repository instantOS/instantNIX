# Example for customizing instantwm packages.
# Copy to repo root and install with:
#     nix-env -iA instantnix -f customization.nix

(import ./.. { pkgs=import <nixpkgs> {}; }).extend (self: super: {
  instantwm = (super.instantwm.override {
    defaultTerminal = self.pkgs.kitty;

    wmconfig = ./customconfig.h;
    # or just patch the original:
    #extraPatches = [ ./some/patch.diff ./an/other/patch.diff ]
  });
})
