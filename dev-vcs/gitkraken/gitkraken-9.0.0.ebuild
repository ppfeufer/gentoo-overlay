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

RDEPEND="
	>=net-print/cups-1.7.0
	>=x11-libs/cairo-1.6.0
	>=sys-libs/glibc-2.17
	>=media-libs/fontconfig-2.11
	media-sound/alsa-utils
	>=dev-libs/atk-2.5.3
	>=app-accessibility/at-spi2-atk-2.9.90
	>=sys-apps/dbus-1.9.14
	>=x11-libs/libdrm-2.4.38
	>=dev-libs/expat-2.0.1
	>=x11-libs/gtk+-3.9.10
	>=dev-libs/nss-3.22
	>=x11-libs/pango-1.14.0
	>=x11-libs/libX11-1.4.99.1
	>=x11-libs/libxcb-1.9.2
	>=x11-libs/libXcomposite-0.3
	>=x11-libs/libXdamage-1.1
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/libxkbcommon-0.5.0
	x11-libs/libXrandr
	dev-libs/libgcrypt
	x11-libs/libnotify
	x11-libs/libXtst
	x11-libs/libxkbfile
	dev-libs/glib
	x11-misc/xdg-utils
"

#TODO: ???
LICENSE="EULA"

QA_PREBUILT="*"

src_install() {
	insinto /usr/share
	doins -r usr/share/{gitkraken,applications,pixmaps,lintian}

	insinto /usr/share/doc/"${P}"
	doins usr/share/doc/gitkraken/copyright

	fperms 755 /usr/share/gitkraken/gitkraken
	fperms 755 /usr/share/gitkraken/chrome-sandbox
	fperms 755 /usr/share/gitkraken/chrome_crashpad_handler
	fperms 755 /usr/share/gitkraken/libEGL.so
	fperms 755 /usr/share/gitkraken/libGLESv2.so
	fperms 755 /usr/share/gitkraken/libffmpeg.so
	fperms 755 /usr/share/gitkraken/libvk_swiftshader.so
	fperms 755 /usr/share/gitkraken/libvulkan.so.1
	fperms 755 /usr/share/gitkraken/resources/bin/gitkraken.sh
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
