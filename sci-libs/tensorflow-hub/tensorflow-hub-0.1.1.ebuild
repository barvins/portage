# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1


DESCRIPTION="TensorFlow Hub is a library for reusable machine learning modules."
HOMEPAGE="https://www.tensorflow.org/hub/"
SRC_URI="https://files.pythonhosted.org/packages/5f/22/64f246ef80e64b1a13b2f463cefa44f397a51c49a303294f5f3d04ac39ac/tensorflow_hub-0.1.1-py2.py3-none-any.whl"



LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${RDEPEND}
	dev-python/numpy
	dev-python/six
	dev-libs/protobuf
"

src_unpack() 
{
	unzip  "${DISTDIR}/${A}" -d "${WORKDIR}/${P}"
}

src_compile()
{
	elog "No compile necessary"
}

src_install()
{
	chmod -R o+r ${S}/tensorflow_hub-0.1.1.dist-info/*
	chmod -R o+r ${S}/tensorflow_hub/*
	
	insinto /usr/lib/python3.6/site-packages/
	doins -r ${S}/tensorflow_hub
	doins -r ${S}/tensorflow_hub-0.1.1.dist-info
	#$cp -r ${S}/* /usr/lib/python3.6/site-packages/
}
