#!/usr/bin/env bash
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -e
set -u
source tests/scripts/setup-pytest-env.sh


# Rebuild cython
make cython3
#riscv gcc
export PATH=/opt/csi-nn2/tools/gcc-toolchain/bin:$PATH
#riscv qemu
export PATH=/opt/csi-nn2/tools/qemu/bin:$PATH

# run qemu tvm_rpc
nohup qemu-riscv64 -cpu c906fdv -L /opt/csi-nn2/tools/gcc-toolchain//sysroot/ ./build-rv/tvm_rpc server --host=127.0.0.1 --port=9090 &

# test
run_pytest ctypes python-csinn2_compute_lib tests/python/contrib/test_csinn
