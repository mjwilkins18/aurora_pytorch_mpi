# PyTorch w/ MPI Backend for ANL Aurora

This repository contains files and instructions to compile PyTorch on ANL Aurora with the MPI distributed backend.

To compile PyTorch, follow these instructions *on a compute node*:
1. Start an interactive job and setup [access to the internet](git@github.com:mjwilkins18/aurora_pytorch_mpi.git).
2. Load the `frameworks` module: `module load frameworks`
3. Clone PyTorch from [Github](https://github.com/pytorch/pytorch) (tested with v2.8).
4. Add "xpu" to list of devices supported by the MPI backend [here](https://github.com/pytorch/pytorch/blob/ed63cb20ecef77cb6928d263d84ff9eb9a207e37/torch/distributed/distributed_c10d.py#L281).
5. Copy the `pytorch_build.sh` script from this repository into the root of the PyTorch directory and run it to compile PyTorch (`./pytorch_build.sh`).
6. Install your PyTorch build as a user package in the `frameworks` module: `pip install --user dist/*`.
7. To test your installation, run `run_dist_test.py` on a multinode interactive job.
8. To understand how to use the MPI backend in your application, use `dist_test.py` as an example.