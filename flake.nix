{
  description = "TkDND - Native drag and drop support for Tcl/Tk";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = {
          tkdnd = pkgs.callPackage ./default.nix { };
          default = self.packages.${system}.tkdnd;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs;
            [ cmake tcl tk ]
            ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
              xorg.libX11
              xorg.libXcursor
            ];
        };
      }) // {
        overlays.default = final: prev: {
          tkdnd = final.callPackage ./default.nix { };
        };
      };
}
