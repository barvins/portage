# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python AST that abstracts the underlying Python version"
HOMEPAGE="https://github.com/serge-sans-paille/gast"
SRC_URI="https://files.pythonhosted.org/packages/5c/78/ff794fcae2ce8aa6323e789d1f8b3b7765f601e7702726f430e814822b96/gast-0.2.0.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
"

#src_unpack() {
#	if [ "${A}" != "" ]; then
#		unpack ${A}
#	fi
#	mv /var/tmp/portage/dev-python/grpcio-1.13.0_pre3/work/grpc-1.13.0-pre3  /var/tmp/portage/dev-python/grpcio-1.13.0_pre3/work/grpcio-1.13.0_pre3
#}
