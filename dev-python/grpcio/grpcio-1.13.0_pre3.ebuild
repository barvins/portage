# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1 git-r3

DESCRIPTION="The C based gRPC (C++, Python, Ruby, Objective-C, PHP, C#)"
HOMEPAGE="https://grpc.io/"
EGIT_REPO_URI="https://github.com/grpc/grpc"
#SRC_URI="https://github.com/grpc/grpc/archive/v1.13.0-pre3.tar.gz"

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
