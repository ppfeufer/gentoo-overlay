# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit unpacker xdg

DESCRIPTION="Advanced cross-platform Dropbox, Google Drive and Microsoft OneDrive client"
HOMEPAGE="https://www.insynchq.com/"

SRC_URI="https://cdn.insynchq.com/builds/linux/${PV}/insync_${PV}-bookworm_amd64.deb"

RESTRICT="strip"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE="wayland kde xfce"

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
)

QA_FLAGS_IGNORED=".*"
QA_PREBUILT="*"

S="${WORKDIR}"

src_install() {
	mv "${S}"/usr/share/doc/insync "${S}"/usr/share/doc/"${PF}"

	mkdir "${S}"/opt

	mv "${S}"/usr/lib/insync "${S}"/opt
	rm -rf "${S}"/usr/lib

	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/Qt3D/Animation/libquick3danimationplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/Qt3D/Core/libquick3dcoreplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/Qt3D/Extras/libquick3dextrasplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/Qt3D/Input/libquick3dinputplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/Qt3D/Logic/libquick3dlogicplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/Qt3D/Render/libquick3drenderplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtBluetooth/libdeclarative_bluetooth.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtDataVisualization/libdatavisualizationqml2.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtGamepad/libdeclarative_gamepad.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtNfc/libdeclarative_nfc.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtPurchasing/libdeclarative_purchasing.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtQml/RemoteObjects/libqtqmlremoteobjects.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtQuick/Scene2D/libqtquickscene2dplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtQuick/Scene3D/libqtquickscene3dplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtRemoteObjects/libqtremoteobjects.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtScxml/libdeclarative_scxml.so

	rm -rf "${S}"/opt/insync/PySide2/Qt/plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/Qt/labs/location/liblocationlabsplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtCharts/libqtchartsqml2.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtLocation/libdeclarative_location.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtPositioning/libdeclarative_positioning.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtQuick/VirtualKeyboard/Settings/libqtquickvirtualkeyboardsettingsplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtQuick/VirtualKeyboard/Styles/libqtquickvirtualkeyboardstylesplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtQuick/VirtualKeyboard/libqtquickvirtualkeyboardplugin.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtSensors/libdeclarative_sensors.so

	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtMultimedia/libdeclarative_multimedia.so
	rm -rf "${S}"/opt/insync/PySide2/Qt/qml/QtQuick/XmlListModel/libqmlxmllistmodelplugin.so

	if use kde || use xfce; then
		rm -rf "${S}"/opt/insync/libstdc++.so.6 # remove libstdc++.so.6 on KDE or Xfce systems
	fi

	if ! use wayland; then
		rm -rf "${S}"/opt/insync/PySide2/plugins/wayland-graphics-integration-server "${S}"/opt/insync/libQt5WaylandCompositor.so.5 || die "Error removing wayland related files from install."
	fi

	cp -a "${S}"/* "${D}" || die "Installation failed"
	docompress -x usr/share/doc/"${PF}"/*.gz
	docompress -x usr/share/man/man1/*.1.gz

	chmod +x "${D}"/opt/insync/lib-dynload/*.so

	dosym /opt/insync/insync /usr/bin/insync

	echo "SEARCH_DIRS_MASK=\"/opt/insync\"" > "${T}"/70-"${PN}" || die
	insinto /etc/revdep-rebuild && doins "${T}"/70-"${PN}" || die
}
