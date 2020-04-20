
# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MULTILIB_COMPAT=( abi_x86_{32,64} )

inherit flag-o-matic meson multilib-minimal ninja-utils

if [[ "${PV}" == "9999" ]]; then
    inherit git-r3
fi

DESCRIPTION="Vulkan-based implementation of D3D9, D3D10 and D3D11 for Linux / Wine"
HOMEPAGE="https://github.com/doitsujin/dxvk"

if [[ "${PV}" == "9999" ]]; then
    EGIT_REPO_URI="https://github.com/doitsujin/dxvk.git"
else
    SRC_URI="https://github.com/doitsujin/dxvk/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="ZLIB"
SLOT="0"

if [[ "${PV}" == "9999" ]]; then
    KEYWORDS=""
else
    KEYWORDS="~amd64 ~x86"
fi

IUSE="+d3d9 +d3d10 +d3d11 +dxgi video_cards_nvidia"

DEPEND="
    dev-util/vulkan-headers
    dev-util/glslang
"

BDEPEND="
    || (
        >=app-emulation/wine-staging-4.5[${MULTILIB_USEDEP},vulkan]
        >=app-emulation/wine-vanilla-4.5[${MULTILIB_USEDEP},vulkan]
    )
"

RDEPEND="
    media-libs/vulkan-loader[${MULTILIB_USEDEP}]
    || (
        video_cards_nvidia? ( >=x11-drivers/nvidia-drivers-440.31 )
        >=media-libs/mesa-19.2
    )
"

PATCHES=(
    "${FILESDIR}/flags.patch"
)

pkg_pretend () {
    if ! use abi_x86_64 && ! use abi_x86_32; then
        eerror "You need to enable at least one of abi_x86_32 and abi_x86_64."
        die
    fi
}

src_prepare() {
    default

    # Filter -march flags as this has been causing issues.
    filter-flags "-march=*"

    sed -i "s|^basedir=.*$|basedir=\"${EPREFIX}\"|" setup_dxvk.sh || die

    # Delete installation instructions for unused ABIs.
    if ! use abi_x86_64; then
        sed -i '/installFile "$win64_sys_path"/d' setup_dxvk.sh || die
    fi

    if ! use abi_x86_32; then
        sed -i '/installFile "$win32_sys_path"/d' setup_dxvk.sh || die
    fi

    add_flags() {
        # Fix installation directory.
        sed -i "s|\"x64\"|\"usr/$(get_libdir)/dxvk\"|" setup_dxvk.sh || die

        # Add *FLAGS to cross-file.
        local bits="${MULTILIB_ABI_FLAG:8:2}"

        sed -i \
            -e "s!@CFLAGS@!$(_meson_env_array "${CFLAGS}")!" \
            -e "s!@CXXFLAGS@!$(_meson_env_array "${CXXFLAGS}")!" \
            -e "s!@LDFLAGS@!$(_meson_env_array "${LDFLAGS}")!" \
            build-wine${bits}.txt || die
    }

    multilib_foreach_abi add_flags
}

multilib_src_configure() {
    local bits="${MULTILIB_ABI_FLAG:8:2}"

    local emesonargs=(
        --libdir="$(get_libdir)/dxvk"
        --bindir="$(get_libdir)/dxvk/bin"
        --cross-file="${S}/build-wine${bits}.txt"
        $(meson_use d3d9 "enable_d3d9")
        $(meson_use d3d10 "enable_d3d10")
        $(meson_use d3d11 "enable_d3d11")
        $(meson_use dxgi "enable_dxgi")
    )

    meson_src_configure
}

multilib_src_compile() {
    EMESON_SOURCE="${S}"

    meson_src_compile
}

multilib_src_install() {
    meson_src_install
}

multilib_src_install_all() {
    dobin setup_dxvk.sh
}

pkg_postinst() {
    elog "dxvk is installed, but not activated. You have to create DLL overrides"
    elog "in order to make use of it. To do so, set WINEPREFIX and execute"
    elog "setup_dxvk.sh install --symlink."

    elog "D9VK is part of DXVK since 1.5. If you use symlinks, don't forget to link the new libraries."
}
