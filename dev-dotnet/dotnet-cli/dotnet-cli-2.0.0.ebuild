# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

#BASED ON https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=dotnet-cli

EAPI="6"

DESCRIPTION=".NET Core cli utility for building, testing, packaging and running projects"
HOMEPAGE="https://www.microsoft.com/net/core"
LICENSE="MIT"

IUSE="heimdal"
SRC_URI="https://download.microsoft.com/download/1/B/4/1B4DE605-8378-47A5-B01B-2C79D6C55519/dotnet-sdk-2.0.0-linux-x64.tar.gz"


SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=sys-libs/libunwind-1.1-r1
	>=dev-libs/icu-57.1
	>=dev-util/lttng-ust-2.8.1
	>=dev-libs/openssl-1.0.2h-r2
	>=net-misc/curl-7.49.0
	heimdal? (
		>=app-crypt/heimdal-1.5.3-r2
	)
	!heimdal? (
		>=app-crypt/mit-krb5-1.14.2
	)
	>=sys-libs/zlib-1.2.8-r1 "

S=${WORKDIR}


src_install() {
	local dest="/opt/dotnet-2.0.0"
	local ddest="${D}/${dest}"

	dodir "${dest}"
	cp -pPR "${S}"/* "${ddest}" || die

	echo "PATH=/opt/dotnet-2.0.0" >> "${T}"/env.d
	echo "ROOTPATH=/opt/dotnet-2.0.0" >> "${T}"/env.d
	newenvd "${T}"/env.d 99dotnet
}

pkg_postinst() {
    ewarn "Run:"
    ewarn "source /etc/profile"
    ewarn "in active shells to get path to dotnet binary"
}