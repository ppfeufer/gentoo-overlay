# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit  cmake-utils

DESCRIPTION="Softphone for VoIP communcations using SIP protocol"
HOMEPAGE="http://twinkle.dolezel.info/"
SRC_URI="https://codeload.github.com/LubosD/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
KEYWORDS="amd64"

LICENSE="GPL-2"
SLOT="0"
IUSE="alsa g729 ilbc speex qt5"

RDEPEND="
    net-libs/ccrtp
    media-libs/fontconfig
    dev-libs/boost
    speex? ( media-libs/speex )
    ilbc? ( media-libs/libilbc )
    g729? ( media-libs/bcg729 )
    alsa? (	media-libs/alsa-lib )
    dev-cpp/commoncpp2
    dev-libs/ucommon
    media-libs/libsndfile
"

REQUIRED_USE="
    ?? ( qt5 )
"

src_configure() {
    local mycmakeargs=(
        $(cmake-utils_use_with alsa ALSA)
        $(cmake-utils_use_with speex SPEEX)
#        $(cmake-utils_use_with ilbc ILBC) #conflicts with libilbc
        $(cmake-utils_use_with qt5 QT5)
#        $(cmake-utils_use_with g729 G729) #would not compile

        -DWITH_G729=OFF
        -DWITH_ZRTP=OFF
    )

    cmake-utils_src_configure
}

S="${WORKDIR}"/${P}
