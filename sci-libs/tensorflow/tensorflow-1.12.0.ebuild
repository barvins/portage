# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
MY_PV=${PV/_rc/-rc}
MY_P=${PN}-${MY_PV}
PIP_P=${P/_rc/rc}

inherit distutils-r1 multiprocessing toolchain-funcs

DESCRIPTION="Computation framework using data flow graphs for scalable machine learning"
HOMEPAGE="https://www.tensorflow.org/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="cuda mpi"
CPU_USE_FLAGS_X86="sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma3 fma4"
for i in $CPU_USE_FLAGS_X86; do
	IUSE+=" cpu_flags_x86_$i"
done

# distfiles that bazel uses for the workspace, will be copied to basel-distdir
bazel_external_uris="
	https://github.com/unicode-org/icu/archive/release-62-1.tar.gz
	http://ftp.exim.org/pub/pcre/pcre-8.42.tar.gz
	http://pilotfiber.dl.sourceforge.net/project/giflib/giflib-5.1.4.tar.gz
	http://www.nasm.us/pub/nasm/releasebuilds/2.13.03/nasm-2.13.03.tar.bz2
	http://ufpr.dl.sourceforge.net/project/swig/swig/swig-3.0.8/swig-3.0.8.tar.gz
	http://www.kurims.kyoto-u.ac.jp/~ooura/fft.tgz
	https://bitbucket.org/eigen/eigen/get/fd6845384b86.tar.gz
	https://curl.haxx.se/download/curl-7.60.0.tar.gz
	https://github.com/LMDB/lmdb/archive/LMDB_0.9.22.tar.gz
	https://github.com/NVlabs/cub/archive/1.8.0.zip -> cub-1.8.0.zip
        https://github.com/abseil/abseil-cpp/archive/48cd2c3f351ff188bc85684b84a91b6e6d17d896.tar.gz
	https://github.com/cython/cython/archive/0.28.4.tar.gz
	https://github.com/glennrp/libpng/archive/v1.6.34.tar.gz
	https://github.com/google/boringssl/archive/7f634429a04abc48e2eb041c81c5235816c96514.tar.gz
	https://github.com/google/farmhash/archive/816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz -> farmhash-816a4ae622e964763ca0862d9dbd19324a1eaf45.tar.gz
	https://github.com/google/flatbuffers/archive/1f5eae5d6a135ff6811724f6c57f911d1f46bb15.tar.gz
	https://github.com/google/nsync/archive/1.20.1.tar.gz
        https://github.com/google/protobuf/archive/v3.6.0.tar.gz
	https://github.com/google/re2/archive/2018-07-01.tar.gz
	https://github.com/google/snappy/archive/1.1.7.tar.gz -> snappy-1.1.7.tar.gz
	https://github.com/hfp/libxsmm/archive/1.9.tar.gz
	https://github.com/intel/ARM_NEON_2_x86_SSE/archive/0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz -> ARM_NEON_2_x86_SSE-0f77d9d182265259b135dad949230ecbf1a2633d.tar.gz
	https://github.com/libjpeg-turbo/libjpeg-turbo/archive/2.0.0.tar.gz
	https://github.com/llvm-mirror/llvm/archive/d3429e96fe1e45b1dc0106463832523f37faf271.tar.gz
	https://github.com/open-source-parsers/jsoncpp/archive/1.8.4.tar.gz
	https://mirror.bazel.build/docs.python.org/2.7/_sources/license.txt -> tensorflow-python-license.txt
	https://pypi.python.org/packages/5c/78/ff794fcae2ce8aa6323e789d1f8b3b7765f601e7702726f430e814822b96/gast-0.2.0.tar.gz
	https://pypi.python.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz
	https://pypi.python.org/packages/bc/cc/3cdb0a02e7e96f6c70bd971bc8a90b8463fda83e264fa9c5c1c98ceabd81/backports.weakref-1.0rc1.tar.gz
	https://pypi.python.org/packages/d8/be/c4276b3199ec3feee2a88bc64810fbea8f26d961e0a4cd9c68387a9f35de/astor-0.6.2.tar.gz
	https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz
	https://zlib.net/zlib-1.2.11.tar.gz
	https://github.com/bazelbuild/rules_closure/archive/dbb96841cc0a5fb2664c37822803b06dab20c7d1.tar.gz
	https://github.com/google/double-conversion/archive/3992066a95b823efc8ccc1baf82a1cfc73f6e9b8.zip
	http://mirror.bazel.build/github.com/google/highwayhash/archive/fd3d9af80465e4383162e4a7c5e2f406e82dd968.tar.gz
	https://mirror.bazel.build/github.com/google/gemmlowp/archive/38ebac7b059e84692f53e5938f97a9943c120d98.zip
	https://www.sqlite.org/2018/sqlite-amalgamation-3240000.zip
	https://github.com/grpc/grpc/archive/v1.13.0.tar.gz
	https://github.com/abseil/abseil-py/archive/pypi-v0.2.2.tar.gz
	https://mirror.bazel.build/github.com/nvidia/nccl/archive/03d856977ecbaac87e598c0c4bafca96761b9ac7.tar.gz
	https://github.com/aws/aws-sdk-cpp/archive/1.3.15.tar.gz
	https://github.com/GoogleCloudPlatform/google-cloud-cpp/archive/14760a86c4ffab9943b476305c4fe927ad95db1c.tar.gz
	https://github.com/googleapis/googleapis/archive/f81082ea1e2f85c43649bee26e0d9871d4b41cdb.zip
	https://github.com/intel/mkl-dnn/archive/v0.12.tar.gz -> mkl_dnn-v0.12.tar.gz
	https://github.com/edenhill/librdkafka/archive/v0.11.5.tar.gz
"



SRC_URI="https://github.com/${PN}/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz
		${bazel_external_uris}"

RDEPEND="
	dev-python/nose
	dev-python/nose-parameterized
	dev-cpp/eigen
	app-arch/snappy
	dev-db/lmdb
	dev-db/sqlite
	dev-libs/libpcre
	dev-libs/protobuf
	dev-libs/protobuf-c
	dev-libs/re2
	dev-python/absl-py[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/termcolor[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	media-libs/giflib
	media-libs/libpng:0
	net-libs/grpc[${PYTHON_USEDEP}]
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg:0
	cuda? ( >=dev-util/nvidia-cuda-toolkit-8.0.61[profiler] >=dev-libs/cudnn-6.0 )
	mpi? ( virtual/mpi )
	sci-libs/keras-applications
	sci-libs/keras-preprocessing
"

DEPEND="${RDEPEND}
	>=dev-util/bazel-0.13.0
	dev-java/java-config
	dev-lang/nasm
	dev-lang/swig"

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS CONTRIBUTING.md ISSUE_TEMPLATE.md README.md RELEASE.md )
PATCHES=(
#	"${FILESDIR}/0001-pip_package-modularize-build-script-to-allow-distros.patch"
#	"${FILESDIR}/tensorflow-1.8.0-0002-dont-strip.patch"
)

bazel-get-cpu-flags() {
	local i f=()
	# Keep this list in sync with tensorflow/core/platform/cpu_feature_guard.cc.
	for i in sse sse2 sse3 sse4_1 sse4_2 avx avx2 fma4; do
		use cpu_flags_x86_${i} && f+=( -m${i/_/.} )
	done
	use cpu_flags_x86_fma3 && f+=( -mfma )
	echo "${f[*]}"
}

bazel-get-flags() {
	local i fs=()
	for i in ${CXXFLAGS} $(bazel-get-cpu-flags); do
		fs+=( "--cxxopt=${i}" "--host_cxxopt=${i}" )
	done
	for i in ${CPPFLAGS}; do
		fs+=( "--copt=${i}" "--host_copt=${i}" )
		fs+=( "--cxxopt=${i}" "--host_cxxopt=${i}" )
	done
	for i in ${LDFLAGS}; do
		fs+=( "--linkopt=${i}" "--host_linkopt=${i}" )
	done
	echo "${fs[*]}"
}

setup_bazelrc() {
	if [[ -f "${T}/bazelrc" ]]; then
		return
	fi

	# F: fopen_wr
	# P: /proc/self/setgroups
	# Even with standalone enabled, the Bazel sandbox binary is run for feature test:
	# https://github.com/bazelbuild/bazel/blob/7b091c1397a82258e26ab5336df6c8dae1d97384/src/main/java/com/google/devtools/build/lib/sandbox/LinuxSandboxedSpawnRunner.java#L61
	# https://github.com/bazelbuild/bazel/blob/76555482873ffcf1d32fb40106f89231b37f850a/src/main/tools/linux-sandbox-pid1.cc#L113
	addpredict /proc

	mkdir -p "${T}/bazel-cache" || die
	mkdir -p "${T}/bazel-distdir" || die

	cat > "${T}/bazelrc" <<-EOF
	startup --batch

	# dont strip HOME, portage sets a temp per-package dir
	build --action_env HOME

	# make bazel respect MAKEOPTS
	build --jobs=$(makeopts_jobs) $(bazel-get-flags)
	build --compilation_mode=opt --host_compilation_mode=opt

	# Use standalone strategy to deactivate the bazel sandbox, since it
	# conflicts with FEATURES=sandbox.
	build --spawn_strategy=standalone --genrule_strategy=standalone
	test --spawn_strategy=standalone --genrule_strategy=standalone

	build --strip=never
	build --verbose_failures --noshow_loading_progress
	test --verbose_test_summary --verbose_failures --noshow_loading_progress

	# make bazel only fetch distfiles from the cache
	fetch --repository_cache=${T}/bazel-cache/ --experimental_distdir=${T}/bazel-distdir/
	build --repository_cache=${T}/bazel-cache/ --experimental_distdir=${T}/bazel-distdir/
	EOF
}

bazel_multibuild_wrapper() {
	BAZEL_OUTPUT_BASE="${WORKDIR}/bazel-base-${MULTIBUILD_VARIANT}"
	mkdir -p "${BAZEL_OUTPUT_BASE}" || die

	run_in_build_dir $@
}

ebazel() {
	setup_bazelrc

	echo Running: bazel --output_base="${BAZEL_OUTPUT_BASE}" "$@"
	bazel --output_base="${BAZEL_OUTPUT_BASE}" $@ || die
}

load_distfiles() {
	# populate the bazel distdir to fetch from since it cannot use the network
	local s d uri rename

	while read uri rename d; do
		[[ -z "$uri" ]] && continue
		if [[ "$rename" == "->" ]]; then
			s="${uri##*/}"
			einfo "Copying $d to bazel distdir $s ..."
		else
			s="${uri##*/}"
			d="${s}"
			einfo "Copying $d to bazel distdir ..."
		fi
		cp "${DISTDIR}/${d}" "${T}/bazel-distdir/${s}" || die
	done <<< "${bazel_external_uris}"
}

pkg_setup() {
	export JAVA_HOME=$(java-config --jre-home)
}

src_unpack() {
	# only unpack the main distfile
	unpack "${P}.tar.gz"
}

src_prepare() {
	BAZEL_OUTPUT_BASE="${WORKDIR}/bazel-base"
	mkdir -p "${BAZEL_OUTPUT_BASE}" || die
	setup_bazelrc
	load_distfiles

	default
	python_copy_sources
}

src_configure() {

	do_configure() {
		#need ulimit -n 2048, or won' link
		python_export PYTHON_SITEDIR
		
		export CC_OPT_FLAGS="${CFLAGS} $(bazel-get-cpu-flags)"
                export TF_NEED_GCP=0
                export TF_NEED_HDFS=0
                export TF_NEED_S3=0
                export TF_NEED_KAFKA=0
                export TF_NEED_IGNITE=0
                export TF_ENABLE_XLA=1
                export TF_NEED_GDR=0
                export TF_NEED_VERBS=0
                export TF_NEED_OPENCL_SYCL=0
                export TF_NEED_OPENCL=0
                export TF_NEED_COMPUTECPP=0
                export TF_NEED_MKL=0
                export TF_NEED_MPI=$(usex mpi 1 0)
                export TF_NEED_CUDA=$(usex cuda 1 0)
                export TF_NEED_TENSORRT=0
                export TF_CUDA_VERSION=10
                export TF_CUDNN_VERSION=7.4.2
                export TF_SET_ANDROID_WORKSPACE=0
                export TF_CUDA_COMPUTE_CAPABILITIES=6.1
                export TF_CUDA_CLANG=0
                export PYTHON_BIN_PATH="${PYTHON}"
                export PYTHON_LIB_PATH="${PYTHON_SITEDIR}"
                #export TENSORRT_INSTALL_PATH="/opt/tensorrt/lib/libnvinfer.so.5.1.2"

		# only one bazelrc is read, import our one before configure sets its options
		echo "import ${T}/bazelrc" >> ./.bazelrc

		# this is not autoconf
		./configure || die
	}
	python_foreach_impl bazel_multibuild_wrapper do_configure
}

src_compile() {
	python_setup
	local MULTIBUILD_VARIANT="${EPYTHON/./_}"
	cd "${S}-${MULTIBUILD_VARIANT}" || die
	BAZEL_OUTPUT_BASE="${WORKDIR}/bazel-base-${MULTIBUILD_VARIANT}"

#		--jobs 1 \
	ebazel build -s\
		--verbose_failures \
		--config=opt $(usex cuda --config=cuda '') \
		//tensorflow:libtensorflow_framework.so \
		//tensorflow:libtensorflow.so \
		//tensorflow:libtensorflow_cc.so

	do_compile() {
		cd "${S}-${MULTIBUILD_VARIANT}" || die
		ebazel build \
			--config=opt $(usex cuda --config=cuda '') \
			//tensorflow/tools/pip_package:build_pip_package
	}
	python_foreach_impl bazel_multibuild_wrapper do_compile
}

src_install() {
	do_install() {
		einfo "Installing ${EPYTHON} files"
		local srcdir="${T}/src-${EPYTHON/./_}"
		#einfo "Fuck: srcdir: ${srcdir}"
		mkdir -p "${srcdir}" || die
		bazel-bin/tensorflow/tools/pip_package/build_pip_package --src "${srcdir}" || die
		cd "${srcdir}" || die
		#einfo "Fuck: esetup.py install"
		esetup.py install

		# it installs site-packages/external but shouldnt
		#einfo "Fuck: python_sitedir: ${PYTHON_SITEDIR}"
		#einfo "Fuck: D: ${D}"
		#einfo "Fuck: P: ${P}"
		#einfo "Fuck: PN: ${PN}"
		#einfo "Fuck: T: ${T}"
		#einfo "Fuck: PIP_P: ${PIP_P}"
		python_export PYTHON_SITEDIR
		rm -rf "${D}/${PYTHON_SITEDIR}/external" || die
		#einfo "Fuck: sed"
		sed -i '/^external/d' "${D}/${PYTHON_SITEDIR}"/${PIP_P}-*.egg-info/{SOURCES,top_level}.txt || die
		#einfo "Fuck: done sed"

		# symlink to the main .so file
		rm -rf "${D}/${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die
		dosym "../../../lib${PN}_framework.so" "${PYTHON_SITEDIR}/${PN}/lib${PN}_framework.so" || die

		python_optimize
	}
	python_foreach_impl bazel_multibuild_wrapper do_install
	
	#einfo "Fuck: do_installs done"

	# symlink to python-exec scripts
	for i in "${D}"/usr/lib/python-exec/*/*; do
		n="${i##*/}"
		[[ -e "${D}/usr/bin/${n}" ]] || dosym ../lib/python-exec/python-exec2 "/usr/bin/$n"
	done

	python_setup
	local MULTIBUILD_VARIANT="${EPYTHON/./_}"
	cd "${S}-${MULTIBUILD_VARIANT}" || die
	BAZEL_OUTPUT_BASE="${WORKDIR}/bazel-base-${MULTIBUILD_VARIANT}"

	einfo "Installing headers"
	# install c c++ and core header files
	for i in $(find ${PN}/{c,cc,core} -name "*.h"); do
		insinto /usr/include/${PN}/${i%/*}
		doins ${i}
	done

	# eigen headers
	insinto /usr/include/${PN}/third_party/eigen3/Eigen/
	doins third_party/eigen3/Eigen/*

	einfo "Installing libs"
	# generate pkg-config file
	${PN}/c/generate-pc.sh --prefix=/usr --version=${MY_PV} || die
	insinto /usr/$(get_libdir)/pkgconfig
	doins ${PN}.pc

	dolib.so bazel-bin/tensorflow/lib${PN}_framework.so
	dolib.so bazel-bin/tensorflow/lib${PN}.so
	dolib.so bazel-bin/tensorflow/lib${PN}_cc.so

	einstalldocs
}
