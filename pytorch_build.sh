#!/bin/bash

export REL_WITH_DEB_INFO=1
export USE_CUDA=0
export USE_ROCM=0
export USE_MKLDNN=1
export USE_MKL=1
export USE_ROCM=0
export USE_CUDNN=0
export USE_FBGEMM=0
export USE_NNPACK=0
export USE_QNNPACK=0
export USE_NCCL=0
export USE_CUDA=0
export BUILD_CAFFE2_OPS=0
export BUILD_TEST=0
export USE_DISTRIBUTED=1
export USE_NUMA=0
export USE_MPI=1
export USE_XCCL=1
export USE_C10D_XCCL=1
export USE_GLOO=0
export USE_XPU=1

export DNNL_GPU_VENDOR=INTEL

export GLIBCXX_USE_CXX11_ABI=1
export CMAKE_PREFIX_PATH=$CMAKE_PREFIX_PATH:/opt/aurora/24.347.0/support/tools/pti-gpu/0.11.0/:/opt/aurora/24.347.0/support/tools/pti-gpu/0.11.0/lib64/cmake/pti/


export INTEL_MKL_DIR=$MKLROOT
export USE_AOT_DEVLIST='pvc'
export TORCH_XPU_ARCH_LIST='pvc'

python -m pip install -r requirements.txt

python setup.py clean

python setup.py bdist_wheel 2>&1 | tee build_whl.log

