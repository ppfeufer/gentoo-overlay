# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker xdg

DESCRIPTION="GitHub Desktop is an open source Electron-based GitHub app"
HOMEPAGE="https://desktop.github.com/"
SRC_URI="https://github.com/shiftkey/desktop/releases/download/release-2.9.9-linux2/GitHubDesktop-linux-2.9.9-linux2.deb"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# use flags
IUSE="alacritty"

RDEPEND="
	>=gnome-base/gconf-3.2.6-r4
	>=x11-libs/libnotify-0.7.8
	>=dev-libs/libappindicator-12.10.0-r301
	>=x11-libs/libXtst-1.2.3-r1
	>=dev-libs/nss-3.51
	>=net-misc/curl-7.68.0
	>=app-crypt/libsecret-0.18.8
	dev-libs/openssl-compat:1.0.0
	gnome-base/gnome-keyring
	alacritty? ( x11-terms/alacritty )
"

DEPEND="${RDEPEND}"

S="${WORKDIR}"
QA_PREBUILT="
	usr/lib64/github-desktop/swiftshader/*.so
	usr/lib64/github-desktop/github-desktop
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-daemon
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-credential-store
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-credential-cache--daemon
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-credential-cache
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-shell
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-sh-i18n--envsubst
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-remote-http
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-lfs
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-imap-send
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-http-push
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-http-fetch
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-http-backend
	usr/lib64/github-desktop/resources/app/git/libexec/git-core/git-fast-import
	usr/lib64/github-desktop/resources/app/git/bin/git
	usr/lib64/github-desktop/*.so
	usr/bin/github-desktop
"

src_install() {
	insinto /usr/share
	doins -r usr/share/{applications,icons,lintian}

	insinto /usr/share/doc/"${P}"
	doins usr/share/doc/github-desktop/copyright

	dodir /usr/lib64/github-desktop
	cp -r usr/lib/github-desktop/. "${ED}/usr/lib64/github-desktop/" || die

	dosym ../lib64/github-desktop/github-desktop /usr/bin/github-desktop
}