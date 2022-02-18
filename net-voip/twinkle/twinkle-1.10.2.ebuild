# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit  cmake xdg-utils

DESCRIPTION="Softphone for VoIP communcations using SIP protocol"
HOMEPAGE="http://twinkle.dolezel.info/"
SRC_URI="https://codeload.github.com/LubosD/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
KEYWORDS="amd64"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa g729 gsm +qt5 speex"

RDEPEND="
	net-libs/ccrtp
	media-libs/fontconfig
	dev-libs/boost
	dev-cpp/commoncpp2
	dev-libs/ucommon
	media-libs/libsndfile
	dev-libs/libxml2
	sys-libs/readline:=
	speex? (
		media-libs/speex
		media-libs/speexdsp
	)
	qt5? (
		dev-qt/qtdeclarative:=[widgets]
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtquickcontrols2:5
		dev-qt/qtwidgets:5
	)
	g729? ( media-libs/bcg729 )
	alsa? (	media-libs/alsa-lib )
"

DEPEND="${RDEPEND}"

BDEPEND="
	qt5? ( dev-qt/linguist-tools )
	sys-devel/bison
	sys-devel/flex
"

src_configure() {
	local mycmakeargs=(
		-DWITH_QT5=$(usex qt5)
		-DWITH_ZRTP=OFF # not ported yet
		-DWITH_ALSA=$(usex alsa)
		-DWITH_SPEEX=$(usex speex)
		-DWITH_ILBC=OFF
		-DWITH_GSM=$(usex gsm)
		-DWITH_G729=OFF
	)

	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}