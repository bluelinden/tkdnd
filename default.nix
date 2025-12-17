{ lib, stdenv, fetchFromGitHub, cmake, tcl, tk, xorg }:

stdenv.mkDerivation rec {
  pname = "tkdnd";
  version = "2.9.5";

  src = ./.;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ tcl tk ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    xorg.libX11
    xorg.libXcursor
  ];

  cmakeFlags = [ "-Dwith-tcl=${tcl}/lib" "-Dwith-tclsh=${tcl}/bin/tclsh" ];

  # Help CMake find Tk includes and stubs
  preConfigure = ''
    export CMAKE_PREFIX_PATH="${tcl}:${tk}"
  '';

  # Install to the correct location for Tcl packages
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/tkdnd${version}
    cp -v lib${pname}${version}${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/tkdnd${version}/
    cp -v library/pkgIndex.tcl $out/lib/tkdnd${version}/
    cp -v ../library/*.tcl $out/lib/tkdnd${version}/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tcl/Tk extension that adds native drag and drop support";
    longDescription = ''
      TkDND is a Tcl/Tk extension that adds native drag and drop capabilities
      to the Tk toolkit. It provides full support for the XDND protocol on Unix,
      OLE DnD on Windows, and Cocoa drag and drop on macOS.
    '';
    homepage = "https://github.com/petasis/tkdnd";
    license = licenses.tcltk;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}
