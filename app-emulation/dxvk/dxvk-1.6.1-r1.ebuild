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
    KEYWORDS="~amd64"
fi

IUSE="+d3d9 +d3d10 +d3d11 debug +dxgi +mingw video_cards_nvidia test winegcc"
REQUIRED_USE="^^ ( mingw winegcc )"

DEPEND="
    dev-util/vulkan-headers
    dev-util/glslang
"

BDEPEND="
    winegcc? ( || (
        >=app-emulation/wine-staging-4.5[${MULTILIB_USEDEP},vulkan]
        >=app-emulation/wine-vanilla-4.5[${MULTILIB_USEDEP},vulkan]
    ) )
"

RDEPEND="
    media-libs/vulkan-loader[${MULTILIB_USEDEP}]
    || (
        video_cards_nvidia? ( >=x11-drivers/nvidia-drivers-440.31 )
        >=media-libs/mesa-19.2
    )
"

PATCHES=(
    "${FILESDIR}/1.6.1-add_compiler_flags.patch"
)

pkg_pretend () {
    if ! use abi_x86_64 && ! use abi_x86_32; then
        eerror "You need to enable at least one of abi_x86_32 and abi_x86_64."
        die
    fi

    if use mingw; then
        local -a categories
        use abi_x86_64 && categories+=("cross-x86_64-w64-mingw32")
        use abi_x86_32 && categories+=("cross-i686-w64-mingw32")

        local thread_model="$(LC_ALL=C ${cat}-gcc -v 2>&1 \
                            | grep 'Thread model' | cut -d' ' -f3)"
        for cat in ${categories[@]}; do
            if ! has_version -b "${cat}/mingw64-runtime[libraries]" ||
                    ! has_version -b "${cat}/gcc" ||
                    [[ "${thread_model}" != "posix" ]]; then
                eerror "The ${cat} toolchain is not properly installed."
                eerror "Make sure to install ${cat}/gcc with EXTRA_ECONF=\"--enable-threads=posix\""
                eerror "and ${cat}/mingw64-runtime with USE=\"libraries\"."
                elog "See <https://wiki.gentoo.org/wiki/Mingw> for more information."
                einfo "In short:"
                einfo "echo '~${cat}/mingw64-runtime-7.0.0 ~amd64' >> \\"
                einfo "    /etc/portage/package.accept_keywords/mingw"
                einfo "crossdev --stable --target ${cat}"
                einfo "echo 'EXTRA_ECONF=\"--enable-threads=posix\"' >> \\"
                einfo "    /etc/portage/env/mingw-gcc.conf"
                einfo "echo '${cat}/gcc mingw-gcc.conf' >> \\"
                einfo "    /etc/portage/package.env/mingw"
                einfo "echo '${cat}/mingw64-runtime libraries' >> \\"
                einfo "    /etc/portage/package.use/mingw"
                einfo "emerge --oneshot ${cat}/gcc ${cat}/mingw64-runtime"

                einfo "Alternatively you can install app-emulation/dxvk-bin from the “guru” repo."
                die "${cat} toolchain is not properly installed."
            fi
        done

        ewarn "Compiling with mingw is experimental. Good luck! :-)"
    elif use winegcc; then
        ewarn "Compiling with winegcc is not supported by upstream."
        ewarn "Please report compile-errors to the package maintainer via"
        ewarn "<https://schlomp.space/tastytea/overlay/issues> or email."
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

    patch_build_flags() {
        local bits="${MULTILIB_ABI_FLAG:8:2}"

        if use mingw; then
            local buildfile="build-win${bits}.txt"
        else
            local buildfile="build-wine${bits}.txt"
        fi

        # Fix installation directory.
        sed -i "s|\"x${bits}\"|\"usr/$(get_libdir)/dxvk\"|" setup_dxvk.sh || die

        # Add *FLAGS to cross-file.
        sed -i \
            -e "s!@CFLAGS@!$(_meson_env_array "${CFLAGS}")!" \
            -e "s!@CXXFLAGS@!$(_meson_env_array "${CXXFLAGS}")!" \
            -e "s!@LDFLAGS@!$(_meson_env_array "${LDFLAGS}")!" \
            "${buildfile}" || die
    }

    multilib_foreach_abi patch_build_flags

    # Load configuration file from /etc/dxvk.conf.
    sed -Ei 's|filePath = "^(\s+)dxvk.conf";$|\1filePath = "/etc/dxvk.conf";|' \
        src/util/config/config.cpp || die
}

multilib_src_configure() {
    local bits="${MULTILIB_ABI_FLAG:8:2}"

    if use mingw; then
        local buildfile="build-win${bits}.txt"
    else
        local buildfile="build-wine${bits}.txt"
    fi

    local emesonargs=(
        --libdir="$(get_libdir)/dxvk"
        --bindir="$(get_libdir)/dxvk"
        --cross-file="${S}/${buildfile}"
        --buildtype="release"
        $(usex debug "" "--strip")
        $(meson_use d3d9 "enable_d3d9")
        $(meson_use d3d10 "enable_d3d10")
        $(meson_use d3d11 "enable_d3d11")
        $(meson_use dxgi "enable_dxgi")
        $(meson_use test "enable_tests")
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
    # The .a files are needed during the install phase.
    use mingw && find "${D}" -name '*.a' -delete -print

    dobin setup_dxvk.sh

    insinto etc

    doins "dxvk.conf"

    default
}

pkg_postinst() {
    elog "dxvk is installed, but not activated. You have to create DLL overrides"
    elog "in order to make use of it. To do so, set WINEPREFIX and execute"
    elog "setup_dxvk.sh install --symlink."

    elog "D9VK is part of DXVK since 1.5. If you use symlinks, don't forget to link the new libraries."
}
