# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit git-r3 cuda cmake-utils

DESCRIPTION="An open source deep learning platform that provides a seamless path from research prototyping to production deployment"
HOMEPAGE="https://pytorch.org/"
EGIT_REPO_URI="https://github.com/pytorch/pytorch.git"


LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="
dev-python/numpy
dev-python/pyyaml
sci-libs/openblas
dev-python/setuptools
dev-util/cmake
dev-python/cffi
dev-python/typing
dev-db/lmdb
dev-libs/leveldb
sci-libs/magma
dev-util/nvidia-cuda-toolkit
dev-libs/cudnn
media-libs/opencv
media-video/ffmpeg
"

src_configure() { 
#   export CXXFLAGS="${CXXFLAGS} -fPIC"
#   export CFLAGS="${CFLAGS} -fPIC"
   local mycmakeargs=( 
      -DUSE_DISTRIBUTED=OFF
      -DUSE_FFMPEG=ON
      -DUSE_NATIVE_ARCH=ON
      -DUSE_OPENMP=ON
      -DTORCH_CUDA_ARCH_LIST=6.1
   ) 
   cmake-utils_src_configure 
}

#src_prepare(){
#    export MAX_JOBS=3
#    export NO_MIOPEN=1
#    export NO_NNPACK=1    
#    export NO_QNNPACK=1    
#    export USE_DISTRIBUTED=OFF
#    export NO_DISTRBUTED=ON
#    export NO_GLOO_IBVERBS=ON
#    export USE_OPENCV=ON
#    export USE_FFMPEG=ON
#    export USE_LEVELDB=ON
#    export USE_LMDB=ON
#    export USE_MKLDNN=OFF
#    export TORCH_CUDA_ARCH_LIST="6.1"
#    eapply_user
#}

# We need write acccess /dev/nvidia0 and /dev/nvidiactl and the portage
# user is (usually) not in the video group
RESTRICT="userpriv"

#python_prepare_all() {
#	cuda_sanitize
#	sed -e "s:'--preprocess':\'--preprocess\', \'--compiler-bindir=$(cuda_gccdir)\':g" \
#		-e "s:\"--cubin\":\'--cubin\', \'--compiler-bindir=$(cuda_gccdir)\':g" \
#		-e "s:/usr/include/pycuda:${S}/src/cuda:g" \
#		-i pycuda/compiler.py || die
#
#	touch siteconf.py || die
#	distutils-r1_python_prepare_all
#}

#python_configure() {
#	mkdir -p "${BUILD_DIR}" || die
#	cd "${BUILD_DIR}" || die
#	rm -f ./siteconf.py || die
#	"${EPYTHON}" "${S}"/configure.py \
#		--boost-inc-dir="${EPREFIX}/usr/include" \
#		--boost-lib-dir="${EPREFIX}/usr/$(get_libdir)" \
#		--boost-python-libname=boost_python-$(echo ${EPYTHON} | sed 's/python//')-mt \
#		--boost-thread-libname=boost_thread-mt \
#		--cuda-root="${EPREFIX}/opt/cuda" \
#		--cudadrv-lib-dir="${EPREFIX}/usr/$(get_libdir)" \
#		--cudart-lib-dir="${EPREFIX}/opt/cuda/$(get_libdir)" \
#		--cuda-inc-dir="${EPREFIX}/opt/cuda/include" \
#		--no-use-shipped-boost \
#		$(usex opengl --cuda-enable-gl "") || die
#}

#src_test() {
#	# we need write access to this to run the tests
#	addwrite /dev/nvidia0
#	addwrite /dev/nvidiactl
#	python_test() {
#		py.test --debug -v -v -v || die "Tests fail with ${EPYTHON}"
#	}
#	distutils-r1_src_test
#}

#python_install_all() {
#	distutils-r1_python_install_all
#	if use examples; then
#		dodoc -r examples
#		docompress -x /usr/share/doc/${PF}/examples
#
#	fi
#}
