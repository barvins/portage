# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1


DESCRIPTION="TensorFlow Probability is a library for probabilistic reasoning and statistical analysis in TensorFlow."
HOMEPAGE="https://github.com/tensorflow/probability"
SRC_URI="https://files.pythonhosted.org/packages/75/8a/82b21bfc7115b8463d3d697aa9add3747c85f447b0b6f903a856b9e78c3f/tensorflow_probability_gpu-0.4.0-py2.py3-none-any.whl"



LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${RDEPEND}
	dev-python/six
	dev-python/numpy
	sci-libs/tensorflow
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
	chmod -R o+r ${S}/tensorflow_probability_gpu-0.4.0.dist-info/*
	chmod -R o+r ${S}/tensorflow_probability/*
	
	insinto /usr/lib/python3.6/site-packages/
	doins -r ${S}/tensorflow_probability
	doins -r ${S}/tensorflow_probability_gpu-0.4.0.dist-info
}
