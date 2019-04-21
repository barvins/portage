
EAPI=6

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1


DESCRIPTION="TensorRT for optimizing and running tensorflow models in production."
HOMEPAGE="https://developer.nvidia.com/tensorrt"
SRC_URI="TensorRT-5.0.2.6.Ubuntu-18.04.1.x86_64-gnu.cuda-10.0.cudnn7.3.tar.gz"



LICENSE="NPLA"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="${RDEPEND}
	dev-libs/cudnn
	dev-util/nvidia-cuda-toolkit
	dev-lang/python
"

src_unpack() 
{

	elog "Extracted to ${WORKDIR}/${P}"
	unpack ${A}
	mv "${WORKDIR}/TensorRT-5.0.2.6" ${WORKDIR}/${P}
	
	unzip "${WORKDIR}/${P}/python/tensorrt-5.0.2.6-py2.py3-none-any.whl" -d "${WORKDIR}/${P}/python"
	unzip "${WORKDIR}/${P}/uff/uff-0.5.5-py2.py3-none-any.whl" -d "${WORKDIR}/${P}/uff"
	unzip "${WORKDIR}/${P}/graphsurgeon/graphsurgeon-0.3.2-py2.py3-none-any.whl" -d "${WORKDIR}/${P}/graphsurgeon"
}

src_compile()
{
	elog "No compile necessary"
}

src_install()
{
	elog "Installing ${S}"
	dodir /opt/tensorrt
	insinto /opt/tensorrt
	doins -r ${S}/data
	doins -r ${S}/doc
	doins -r ${S}/include
	doins -r ${S}/targets
	doins ${S}/TensorRT-Release-Notes.pdf
	doins -r ${S}/bin
	doins -r ${S}/lib
	doins -r ${S}/samples
	dodir /opt/tensorrt/python
	insinto /opt/tensorrt/python
	doins -r ${S}/python/data
	fperms -R 0666 /opt/tensorrt/data
	fperms -R 0666 /opt/tensorrt/samples
	fperms -R 0666 /opt/tensorrt/python/data
	fperms 0777 /opt/tensorrt/bin
	fperms -R 0777 /opt/tensorrt/bin
	
	chmod -R o+r ${S}/python/tensorrt-5.0.2.6.dist-info/*
	chmod -R o+r ${S}/python/tensorrt/*
	insinto /usr/lib/python3.6/site-packages/
	doins -r ${S}/python/tensorrt
	doins -r ${S}/python/tensorrt-5.0.2.6.dist-info
	fperms -R 0755 /usr/lib/python3.6/site-packages/tensorrt/*.so
	
	chmod -R o+r ${S}/uff/uff-0.5.5.dist-info/*
	chmod -R o+r ${S}/uff/uff/*
	insinto /usr/lib/python3.6/site-packages/
	doins -r ${S}/uff/uff
	doins -r ${S}/uff/uff-0.5.5.dist-info
	
	chmod -R o+r ${S}/graphsurgeon/graphsurgeon-0.3.2.dist-info/*
	chmod -R o+r ${S}/graphsurgeon/graphsurgeon/*
	insinto /usr/lib/python3.6/site-packages/
	doins -r ${S}/graphsurgeon/graphsurgeon
	doins -r ${S}/graphsurgeon/graphsurgeon-0.3.2.dist-info
	
        dodir /etc/env.d
        ENV_FILE="${D}/etc/env.d/99tensorrt"
        echo 'PATH="/opt/tensorrt/bin"' >> ${ENV_FILE}
        echo 'LDPATH="/opt/tensorrt/lib"' >> ${ENV_FILE}
        echo 'TENSORRT_INSTALL_PATH="/opt/tensorrt"' >> ${ENV_FILE}
}
