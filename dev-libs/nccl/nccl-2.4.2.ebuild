
EAPI=6

#inherit distutils-r1


DESCRIPTION="NVIDIA Collective Communications Library"
HOMEPAGE="https://developer.nvidia.com/nccl"
SRC_URI="nccl_${PV}-1+cuda10.1_x86_64.txz"



LICENSE="NPLA"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${RDEPEND}
	dev-util/nvidia-cuda-toolkit
"

src_unpack() 
{

	elog "Extracting to ${WORKDIR}/${P}"
	unpack ${A}
	mv "${WORKDIR}/nccl_${PV}-1+cuda10.1_x86_64" ${WORKDIR}/${P}
}

src_compile()
{
	elog "No compile necessary"
}

src_install()
{
	elog "Installing ${S}"
	insinto /opt/cuda/include
	doins -r ${S}/include/*
	insinto /opt/cuda/lib64
	doins -r ${S}/lib/*
	
        dodir /etc/env.d
        ENV_FILE="${D}/etc/env.d/99nccl"
        echo 'NCCL_INSTALL_PATH="/opt/cuda"' >> ${ENV_FILE}
}
