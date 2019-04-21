
# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

#EGIT_REPO_URI="git://github.com/BVLC/caffe.git"
EGIT_REPO_URI="git://github.com/NVIDIA/caffe"
PYTHON_COMPAT=( python2_7 )

inherit toolchain-funcs multilib git-r3 python-single-r1
# Can't use cuda.eclass as nvcc does not like --compiler-bindir set there for some reason

DESCRIPTION="Deep learning framework by the BVLC"
HOMEPAGE="http://caffe.berkeleyvision.org/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE="cuda -python"

PATCHES="
${FILESDIR}/Dependencies.cmake.patch
${FILESDIR}/FindOpenBLAS.cmake.patch
"

#MAKEOPTS="-j3"

CDEPEND="
	dev-libs/boost:=[python]
	media-libs/opencv:=
	dev-libs/protobuf:=
	dev-cpp/glog:=
	dev-cpp/gflags:=
	sci-libs/hdf5:=
	dev-libs/leveldb:=
	app-arch/snappy:=
	dev-db/lmdb:=
	cuda? (
		dev-util/nvidia-cuda-toolkit
	)
	${PYTHON_DEPS}
"
DEPEND="
	${CDEPEND}
	sys-devel/bc
"
RDEPEND="
	${CDEPEND}
	python? (
		dev-python/pandas
		dev-python/numpy
		sci-libs/scikits_image
	)
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

pkg_setup() {
	python-single-r1_pkg_setup
}


src_configure() {
	# Respect CFLAGS
	#sed -e '/COMMON_FLAGS/s/-O2//' -i Makefile


	cat > Makefile.config << EOF
OPENCV_VERSION := 3
BUILD_DIR := build
DISTRIBUTE_DIR := distribute
BLAS := open
BLAS_INCLUDE := /usr/include/openblas
BLAS_LIB := /usr/lib
USE_PKG_CONFIG := 1
LIBRARY_NAME_SUFFIX := -nv
EOF
#BLAS_LIB := /usr/lib/libopenblas_threads.so

	if use cuda; then
		cat >> Makefile.config << EOF
CUDA_DIR := ${EPREFIX}/opt/cuda
USE_CUDNN := 1
EOF

		# This should be handled by Makefile itself, but somehow is broken
		#sed -e "/CUDA_LIB_DIR/s/lib/$(get_libdir)/" -i Makefile || die "sed failed"
	else
		echo "CPU_ONLY := 1" >> Makefile.config
	fi
	
	
#/usr/lib/libboost_python-2.7.so
#/usr/lib/libpython2.7.so


	python_export PYTHON_INCLUDEDIR PYTHON_SITEDIR PYTHON_LIBPATH
	cat >> Makefile.config << EOF
PYTHON_INCLUDE := "${PYTHON_INCLUDEDIR}" "${PYTHON_SITEDIR}/numpy/core/include"
PYTHON_LIB := "$(dirname ${PYTHON_LIBPATH})"



INCLUDE_DIRS += \$(PYTHON_INCLUDE)
LIBRARY_DIRS += \$(PYTHON_LIB)
EOF

	if use python; then
		echo "WITH_PYTHON_LAYER := 1" >> Makefile.config
		echo "PYTHON_LIBRARIES := boost_python-2.7 python2.7 boost_regex" >> Makefile.config
	fi

	#boost-python-py is wrong, correct is boost-python-3.6
#	local py_version=${EPYTHON#python}
	sed -e "s/LIBRARIES += openblas/LIBRARIES += openblas_openmp/g" -i Makefile || die "openblas_openmp sed failed"

#	sed -e 's/boost_python-py${python_version_major}${python_version_minor}/boost_python-${python_version_major}.${python_version_minor}/' \
#		-i Makefile || die "boost sed failed"

#	sed -e '/blas/s/atlas//' \
#		-e '/^LINKFLAGS +=/ a\
#		LINKFLAGS += -L$(LIB_BUILD_DIR)
#		' \
#		-i Makefile || die "LINKFLAGS sed failed"

	tc-export CC CXX
}

src_compile() {
	emake

	use python && emake pycaffe
}

src_test() {
	emake runtest

	use python && emake pytest
}

src_install() {
	emake distribute

	for bin in distribute/bin/*; do
		local name=$(basename ${bin})
		newbin ${bin} ${name//.bin/}
	done

	insinto /usr
	doins -r distribute/include/

	dolib.a distribute/lib/libcaffe*.a*
	dolib.so distribute/lib/libcaffe*.so*

	#install CMake config
	insinto /usr/$(get_libdir)/cmake
	doins ${FILESDIR}/CaffeConfig.cmake

	if use python; then
		rm distribute/python/caffe/_caffe.cpp || die "rm failed"
		python_domodule distribute/python/caffe
		for script in distribute/python/*.py; do
			python_doscript ${script}
		done
	fi
}


#/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lboost_python-py27
#/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lopenblas


#Ly"/usr/lib64" -L"/opt/cuda"/lib -L/cuda/lib64 -L/lib64 -L/usr/lib/x86_64-linux-gnu/hdf5/serial -L/usr/lib/libopenblas_threads.so -L.build_release/lib -lopencv_cudabgsegm -lopencv_cudaobjdetect -lopencv_cudastereo -lopencv_dnn -lopencv_ml -lopencv_shape -lopencv_stitching -lopencv_cudafeatures2d -lopencv_superres -lopencv_cudacodec -lopencv_videostab -lopencv_cudaoptflow -lopencv_cudalegacy -lopencv_calib3d -lopencv_features2d -lopencv_highgui -lopencv_videoio -lopencv_photo -lopencv_imgcodecs -lopencv_cudawarping -lopencv_cudaimgproc -lopencv_cudafilters -lopencv_video -lopencv_objdetect -lopencv_imgproc -lopencv_flann -lopencv_cudaarithm -lopencv_core -lopencv_cudev -lcudart -lcublas -lcurand -lnvidia-ml -lboost_system -lglog -lgflags -lprotobuf -lboost_filesystem -lm -lturbojpeg -lhdf5_hl -lhdf5 -lleveldb -lsnappy -llmdb -lopencv_core -lopencv_highgui -lopencv_imgproc -lopencv_imgcodecs -lopencv_videoio -lboost_thread -lboost_regex -lstdc++ -lcudnn -lboost_python-py27 -lpython2.7 -lboost_regex -lopenblas 
#/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lcudart
#/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lcublas
#/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lcurand
#/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lcudnn
#/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lboost_python-py27
#/usr/lib/gcc/x86_64-pc-linux-gnu/7.3.0/../../../../x86_64-pc-linux-gnu/bin/ld: cannot find -lopenblas
