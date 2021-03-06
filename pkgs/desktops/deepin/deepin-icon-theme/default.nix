{ stdenv, fetchFromGitHub, gtk3, xcursorgen, papirus-icon-theme, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "deepin-icon-theme";
  version = "15.12.68";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "12jgz81s5qggmnkfg9m5f799r10p43qmh4zqxl1kjvlrqgvsc9rf";
  };

  nativeBuildInputs = [ gtk3 xcursorgen ];

  buildInputs = [ papirus-icon-theme ];

  postPatch = ''
    patchShebangs tools/hicolor.links
    patchShebangs tools/display_unused_links.sh
    patchShebangs cursors-src/cursors/bitmaps/make.sh
    patchShebangs cursors-src/render-cursors.sh

    # keep icon-theme.cache
    sed -i -e 's|\(-rm -f .*/icon-theme.cache\)|# \1|g' Makefile
  '';

  buildTargets = "all hicolor-links";
  installTargets = "install-icons install-cursors";
  installFlags = [ "PREFIX=${placeholder ''out''}" ];

  postInstall = ''
    cp -a ./Sea ./usr/share/icons/hicolor "$out"/share/icons/
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Icons for the Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/deepin-icon-theme;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ romildo ];
  };
}
