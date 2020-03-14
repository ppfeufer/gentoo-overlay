# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit rpm

DESCRIPTION="Advanced cross-platform Google Drive client"
HOMEPAGE="https://www.insynchq.com/"

MAGIC="37371"
MAIN_INSTALLER_STRING="http://s.insynchq.com/builds/insync-${PV}.${MAGIC}-fc26"

SRC_URI="
    amd64?    ( ${MAIN_INSTALLER_STRING}.x86_64.rpm )"

LICENSE="as-is"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_unpack() {
    rpm_src_unpack ${A}
    mkdir -p "${S}" # Without this src_prepare fails
}

src_install() {
    cp -pPR "${WORKDIR}"/{usr,etc} "${D}"/ || die "Installation failed"

    echo "SEARCH_DIRS_MASK=\"/usr/lib*/insync\"" > "${T}/70${PN}" || die
    insinto "/etc/revdep-rebuild" && doins "${T}/70${PN}" || die
}

pkg_postinst() {
    elog "To automatically start insync add 'insync start' to your session"
    elog "startup scripts. GNOME users can also choose to enable"
    elog "the insync extension via gnome-tweak-tool."
}
