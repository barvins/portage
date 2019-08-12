# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1


DESCRIPTION="TensorFlow's Visualization Toolkit"
HOMEPAGE="https://github.com/tensorflow/tensorboard"
SRC_URI="https://files.pythonhosted.org/packages/0f/39/bdd75b08a6fba41f098b6cb091b9e8c7a80e1b4d679a581a0ccd17b10373/tensorboard-1.13.1-py3-none-any.whl"


LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${RDEPEND}
	dev-python/numpy
	dev-python/six
	dev-lang/nasm
	dev-lang/swig
	dev-python/astor
	dev-python/markdown
	dev-python/gast
	dev-python/grpcio
	dev-python/wheel
	dev-python/werkzeug
	sci-libs/tensorflow-estimator"

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
	chmod -R o+r ${S}/tensorboard-${PV}.dist-info/*
	chmod -R o+r ${S}/tensorboard/*
	
	insinto /usr/lib/python3.6/site-packages/
	doins -r ${S}/tensorboard
	doins -r ${S}/tensorboard-${PV}.dist-info
	#$cp -r ${S}/* /usr/lib/python3.6/site-packages/
}
