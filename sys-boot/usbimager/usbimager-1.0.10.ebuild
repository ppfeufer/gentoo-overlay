# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit desktop xdg-utils unpacker

DESCRIPTION="Minimal GUI for writing compressed disk images to USB drives"
HOMEPAGE="https://gitlab.com/bztsrc/${PN}"
LICENSE="public-domain BSD BZIP2 MIT ZLIB"
SRC_URI="https://gitlab.com/bztsrc/usbimager/raw/binaries/usbimager_${PV}-amd64.deb"

SLOT="0"
IUSE=""
RESTRICT="mirror"
KEYWORDS="~amd64 ~arm ~arm64"

RDEPEND="
	sys-fs/udisks
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/desktop-file.patch"
)

S="${WORKDIR}"

QA_FLAGS_IGNORED=".*"
QA_PREBUILT="*"

src_install() {
	rm -rf "${S}"/usr/share/man/

	cp -a "${S}"/* "${D}" || die "Installation failed"
}
