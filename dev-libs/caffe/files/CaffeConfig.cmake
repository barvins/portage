# Compute paths
set(Caffe_INCLUDE_DIRS "/usr/include" "/opt/cuda/include")

#pkg_check_modules(MY_CBLAS cblas)
#set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${MY_CBLAS_CFLAGS}")
#message("Zirnis: CMAKE_C_FLAGS")

# List of IMPORTED libs created by CaffeTargets.cmake
set(Caffe_LIBRARIES caffe-nv cuda cudart glog)

# Cuda support variables
set(Caffe_CPU_ONLY 0)
set(Caffe_HAVE_CUDA 1)
set(Caffe_HAVE_CUDNN 0)
