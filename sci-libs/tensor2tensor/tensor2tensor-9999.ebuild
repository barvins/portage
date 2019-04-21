# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1 git-r3

DESCRIPTION="Library of deep learning models and datasets designed to make deep learning more accessible and accelerate ML research."
HOMEPAGE="https://github.com/tensorflow/tensor2tensor"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"


#SRC_URI=""

EGIT_REPO_URI="https://github.com/tensorflow/tensor2tensor"

RDEPEND="
dev-python/bz2file
dev-python/flask
dev-python/future
dev-python/google-api-python-client
dev-python/gevent
www-servers/gunicorn
dev-python/h5py
dev-python/numpy
dev-python/oauth2client
dev-python/requests
sci-libs/scipy
dev-python/sympy
dev-python/six
dev-python/gym
dev-python/tqdm
sci-libs/tensorflow
dev-python/pytest
dev-python/mock
dev-python/pylint
dev-python/jupyter
net-misc/gsutil
"


