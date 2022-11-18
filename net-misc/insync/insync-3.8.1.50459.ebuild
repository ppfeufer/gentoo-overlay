# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="Advanced cross-platform Dropbox, Google Drive and Microsoft OneDrive client"
HOMEPAGE="https://www.insynchq.com/"

SRC_URI="https://cdn.insynchq.com/builds/linux/insync_${PV}-bullseye_amd64.deb"

RESTRICT="strip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
	>=sys-libs/glibc-2.31
	x11-misc/xdg-utils
	dev-libs/nss
	app-crypt/gnupg
	dev-libs/libthai
	sys-devel/gcc
"

PATCHES=(
	"${FILESDIR}/insync-3-fix-ca-path.patch"
	"${FILESDIR}/insync-3-lib64.patch"
)

QA_FLAGS_IGNORED=".*"
QA_PREBUILT="*"

src_unpack() {
	unpack "insync_${PV}-bullseye_amd64.deb"
	unpack ${WORKDIR}"/data.tar.gz"

	mkdir -p "${S}"
	mv "${WORKDIR}"/usr "${S}"/
}

src_install() {
	gzip -d usr/share/doc/insync/changelog.gz
	dodoc usr/share/doc/insync/changelog

	rm -rf "${WORKDIR}"/"${P}"/usr/share/doc/

	cp -pPR "${WORKDIR}"/"${P}"/usr/ "${D}"/ || die "Installation failed"
	mv "${D}"/usr/lib "${D}"/usr/lib64

	rm -Rf "${D}"/usr/lib64/.build-id
	rm -rf "${D}"/usr/share/man/man1/

	# Make sure it starts on KDE
	# There is a bug that on some KDE systems Insync doesn't start properly
	# Or crashes when the tray icon is clicked
	# This is because Insync is using bundled libstdc++.so.6 which might lead to a version conflict
	# So we remove it here
	rm -Rf "${D}"/usr/lib64/insync/libstdc++.so.6

	echo "SEARCH_DIRS_MASK=\"/usr/lib*/insync\"" > "${T}/70-${PN}" || die

	insinto "/etc/revdep-rebuild" && doins "${T}/70-${PN}" || die

	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/insync-helper.xml
}
