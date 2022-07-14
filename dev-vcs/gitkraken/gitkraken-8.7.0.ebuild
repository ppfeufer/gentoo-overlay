# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg
DESCRIPTION="cross-platform Git client"
HOMEPAGE="https://www.gitkraken.com"
SRC_URI="https://release.axocdn.com/linux/GitKraken-v${PV}.deb"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="strip"
S="${WORKDIR}"

RDEPEND="net-print/cups"

#TODO: ???
LICENSE="EULA"

#src_prepare() {
#	unpack ./control.tar.xz
#	unpack ./data.tar.xz
#
#	default
#}

src_install() {
	insinto /usr/share
	doins -r usr/share/{gitkraken,applications,pixmaps,lintian}

	insinto /usr/share/doc/"${P}"
	doins usr/share/doc/gitkraken/copyright

	#doins -r usr

	fperms 755 /usr/share/gitkraken/gitkraken
	fperms 755 /usr/share/gitkraken/resources/bin/gitkraken.sh
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}