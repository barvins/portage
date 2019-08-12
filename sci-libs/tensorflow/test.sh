(cd /var/tmp/portage/sci-libs/tensorflow-1.13.1/work/bazel-base-python3_6/execroot/org_tensorflow && \
  exec env - \
    CUDA_TOOLKIT_PATH=/opt/cuda \
    CUDNN_INSTALL_PATH=/opt/cuda \
    GCC_HOST_COMPILER_PATH=/usr/x86_64-pc-linux-gnu/gcc-bin/8.2.0/gcc \
    HOME=/var/tmp/portage/sci-libs/tensorflow-1.13.1/homedir \
    PATH=/bin:/usr/bin \
    PWD=/proc/self/cwd \
    PYTHON_BIN_PATH=/usr/bin/python3.6 \
    PYTHON_LIB_PATH=/usr/lib64/python3.6/site-packages \
    TF_CUDA_CLANG=0 \
    TF_CUDA_COMPUTE_CAPABILITIES=6.1 \
    TF_CUDA_VERSION=10.1 \
    TF_CUDNN_VERSION=7 \
    TF_NCCL_VERSION='' \
    TF_NEED_CUDA=1 \
    TF_NEED_OPENCL_SYCL=0 \
    TF_NEED_ROCM=0 \
  /usr/bin/ar @bazel-out/k8-opt/bin/external/nccl_archive/libprod.pic.a-2.params)
