# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
DISTUTILS_OPTIONAL=1
inherit cmake-utils eutils distutils-r1 git-r3

DESCRIPTION="Flexible and Efficient Library for Deep Learning"
HOMEPAGE="http://mxnet.io/"
#EGIT_REPO_URI="https://github.com/dmlc/mxnet"
EGIT_REPO_URI="https://github.com/apache/incubator-mxnet"

#EGIT_SUBMODULES=( "*" "-dmlc-core" "-nnvm" "-ps-lite" )

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="cuda distributed opencv openmp python +mxnet_blas_mkl mxnet_blas_openblas mxnet_blas_atlas"

#,openmp=]

RDEPEND="
	sys-devel/gcc[cxx]
	openmp? ( dev-python/lit )
	mxnet_blas_mkl? ( ~sci-libs/mkl-2017.3.196 )
	mxnet_blas_openblas? ( sci-libs/openblas )
	mxnet_blas_atlas? ( sci-libs/atlas )
	cuda? ( dev-util/nvidia-cuda-toolkit )
	distributed? ( sci-libs/ps-lite )
	opencv? ( media-libs/opencv )
	python? ( ${PYTHON_DEPS} dev-python/numpy[${PYTHON_USEDEP}] )"
DEPEND="${RDEPEND}
	python? ( dev-python/setuptools[${PYTHON_USEDEP}] )"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	^^ (
		mxnet_blas_mkl
		mxnet_blas_openblas
		mxnet_blas_atlas
	)"

#PATCHES=( "${FILESDIR}/${P}-build-fix.patch" "${FILESDIR}/${P}-fix-python-stupid.patch" )
#PATCHES=( "${FILESDIR}/${P}-fix-python-stupid.patch" )
#PATCHES=( "${FILESDIR}/${P}-build-fix.patch" )

pkg_setup() {
	lsmod|grep -q '^nvidia_uvm'
	if [ $? -ne 0 ] || [ ! -c /dev/nvidia-uvm ]; then
		eerror "Please run: \"nvidia-modprobe -u -c 0\" before attempting to install ${PN}."
		eerror "Otherwise the hardware autodetect will fail and all architecture modules will be built."
	fi
}

src_prepare() {
	default
	#specific commit, because it is broken later
	git reset --hard b434b8ec18f774c99b0830bd3ca66859212b4911
	cd "${S}/cmake/Modules"
	epatch "${FILESDIR}/${P}-openblas-fix.patch"
	if use python; then
		cd "${S}/python"
		epatch "${FILESDIR}/${P}-fix-python2.patch"
		cd "${S}/python/mxnet"
		epatch "${FILESDIR}/${P}-fix-python1.patch"
		cd "${S}"/python
		distutils-r1_src_prepare
	fi
#	if use cuda; then
#		cd "${S}"/mshadow
#		epatch "${FILESDIR}/${P}-fix-c++11.patch"
#	fi
	if use distributed; then
		cd "${S}"
		epatch "${FILESDIR}/${P}-link-shared-zmq.patch"
	fi
	cd "${S}"
	epatch "${FILESDIR}/${P}-f16c-fix.patch"
#	epatch "${FILESDIR}/${P}-fix-lapack.patch"
#	epatch "${FILESDIR}/${P}-fix-lapack2.patch"
}

src_configure() {
	local mycmakeargs=(
		#-DBUILD_SHARED_LIBS=ON
		-DUSE_CUDA=$(usex cuda)
		-DCUDA_ARCH_LIST="6.1+PTX"
		-DUSE_OPENCV=$(usex opencv)
		-DUSE_OPENMP=$(usex openmp)
		-DUSE_DIST_KVSTORE=$(usex distributed)
		-DUSE_LAPACK=0
	)

	if use mxnet_blas_mkl; then
		einfo "BLAS provided by Intel Math Kernel Library"
		get_major_version 
		mycmakeargs+=(
			-DBLAS=MKL
			-DUSE_MKLML_MKL=OFF
		)
		export MKL_ROOT=$(find /opt/intel -xtype d -regextype posix-extended -regex '.*compilers_and_libraries_[[:digit:]\.]+/linux/mkl$')
		if [[ -z ${MKL_ROOT} ]]; then
			eerror "Cannot find intel library in /opt/intel."
			return 0
		fi
	elif use mxnet_blas_openblas; then
		einfo "BLAS provided by OpenBLAS"
		mycmakeargs+=( 
			-DBLAS=Open
		)
		mycmakeargs+=( 
			-DUSE_MKLDNN=0
		)

	elif use mxnet_blas_atlas; then
		einfo "BLAS provided by ATLAS"
		mycmakeargs+=( 
			-DBLAS=Atlas
		)
	fi

	addwrite /dev/nvidia-uvm
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia0

	cmake-utils_src_configure

	if use python; then
		cd python;
		distutils-r1_src_configure
	fi
}

src_compile() {
	cmake-utils_src_compile


	if use python; then
		elog "CD python"
		cd python
		elog "Export path: ${LD_LIBRARY_PATH}:${BUILD_DIR}"
		export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${BUILD_DIR}"
		elog "Compile python"
		distutils-r1_src_compile
		elog "Done python"
	fi
}

src_install() {
	doheader -r include/mxnet

	if use python; then
		cd python
		distutils-r1_src_install
	fi

	cd "${BUILD_DIR}"
	dolib.so libmxnet.so
	#cd "${BUILD_DIR}/3rdparty/openmp/runtime/src"
	#newlib.so libomp.so libomp.so.4.5
}
