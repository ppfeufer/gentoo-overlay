 
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Enpass password manager"
HOMEPAGE="https://www.enpass.io/"
SRC_URI="https://apt.enpass.io/pool/main/e/enpass/enpass_${PV}_amd64.deb"

LICENSE="SINEW"
SLOT="0"
KEYWORDS="amd64"

inherit unpacker

RDEPEND="
    x11-libs/libXScrnSaver
    sys-process/lsof
    net-misc/curl
"
    

S="${WORKDIR}"

src_install() {
    insinto /

    # install in /opt/enpass
    ENPASS_HOME=/opt/enpass

    doins -r usr/

    doins -r opt/

    fperms +x ${ENPASS_HOME}/Enpass
    fperms +x ${ENPASS_HOME}/importer_enpass

    dosym ${ENPASS_HOME}/Enpass /usr/bin/enpass
}

pkg_postinst() {
    gnome2_icon_cache_update
    xdg_mimeinfo_database_update
    xdg_desktop_database_update
}

pkg_postrm() {
    gnome2_icon_cache_update
    xdg_mimeinfo_database_update
    xdg_desktop_database_update
}
