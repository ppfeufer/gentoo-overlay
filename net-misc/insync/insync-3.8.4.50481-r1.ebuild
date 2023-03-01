# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Advanced cross-platform Dropbox, Google Drive and Microsoft OneDrive client"
HOMEPAGE="https://www.insynchq.com/"

SRC_URI="https://cdn.insynchq.com/builds/linux/insync_${PV}-bullseye_amd64.deb"

RESTRICT="strip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="wayland"

RDEPEND="
	app-crypt/gnupg
	dev-libs/libthai
	dev-libs/nss
	dev-qt/qtvirtualkeyboard
	sys-devel/gcc
	>=sys-libs/glibc-2.31
	x11-misc/xdg-utils
	wayland? (
		dev-libs/wayland
	)
"

PATCHES=(
	"${FILESDIR}/insync-3-fix-desktop-file.patch"
	"${FILESDIR}/insync-3-lib64.patch"
)

QA_FLAGS_IGNORED=".*"
QA_PREBUILT="*"

src_unpack() {
	unpack "insync_${PV}-bullseye_amd64.deb"
	unpack "${WORKDIR}/data.tar.gz"

	mkdir -p "${S}"/opt
	mv  "${WORKDIR}"/usr "${S}"/
	mv "${S}"/usr/lib/insync "${S}"/opt/insync

}

src_install() {
	insinto /

	gzip -d usr/share/doc/insync/changelog.gz
	dodoc usr/share/doc/insync/changelog
	rm -rf "${WORKDIR}"/"${P}"/usr/share/doc

	dobin usr/bin/insync
	rm -rf "${WORKDIR}"/"${P}"/usr/bin

	mkdir -p "${D}"/opt
	mv  "${S}"/opt/insync "${D}"/opt/insync || die "Installation failed"
	cp -pPR  "${WORKDIR}"/"${P}"/usr/share "${D}"/usr || die "Installation failed"

	rm -Rf "${D}"/opt/insync/.build-id
	rm -rf "${D}"/usr/share/man/man1/

	use wayland || rm -r "${D}/opt/insync/PySide2/plugins/wayland-graphics-integration-server" "${D}/opt/insync/libQt5WaylandCompositor.so.5" || die "Error removing wayland related files from install."

	# Make sure it starts on KDE
	# There is a bug that on some KDE systems Insync doesn't start properly
	# Or crashes when the tray icon is clicked
	# This is because Insync is using bundled libstdc++.so.6 which might lead to a version conflict
	# So we remove it here
	rm -Rf "${D}"/opt/insync/libstdc++.so.6

	echo "SEARCH_DIRS_MASK=\"/opt/insync\"" > "${T}/70-${PN}" || die

	insinto "/etc/revdep-rebuild" && doins "${T}/70-${PN}" || die

	insinto /usr/share/mime/packages
	doins usr/share/mime/packages/insync-helper.xml
}
