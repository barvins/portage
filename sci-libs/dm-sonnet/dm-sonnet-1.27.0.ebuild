# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1


DESCRIPTION="Sonnet is a library built on top of TensorFlow for building complex neural networks."
HOMEPAGE="https://github.com/deepmind/sonnet"
SRC_URI="https://files.pythonhosted.org/packages/5b/fe/176ba5d2e20a9ea785ef7dc72022b807481c265f5069e00c4f058fae20af/dm_sonnet_gpu-1.27-py3-none-any.whl"



LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${RDEPEND}
	dev-python/six
	dev-python/absl-py
	dev-python/semantic_version
	dev-python/contextlib2
	sci-libs/tensorflow
	sci-libs/tensorflow-probability
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
	chmod -R o+r ${S}/dm_sonnet_gpu-1.27.dist-info/*
	chmod -R o+r ${S}/sonnet/*
	
	insinto /usr/lib/python3.6/site-packages/
	doins -r ${S}/sonnet
	doins -r ${S}/dm_sonnet_gpu-1.27.dist-info
	#$cp -r ${S}/* /usr/lib/python3.6/site-packages/
}
