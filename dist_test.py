import torch.nn.parallel
import torch.distributed as dist
import os

def setup_distributed(backend='mpi'):
    # Initialize the distributed environment.
    dist.init_process_group(backend=backend)

def get_default_device(rank):
    if torch.xpu.is_available():
        return torch.device(f"xpu:{rank%12}")
    else:
        return torch.device('cpu')

def cleanup_distributed():
    # Clean up the distributed environment.
    dist.destroy_process_group()

def test_allreduce():
    # Set up the distributed environment
    setup_distributed()

    # Get the rank of the current process
    rank = dist.get_rank()
    size = dist.get_world_size()

    device = get_default_device(rank)

    # Create a tensor with 1 as its value
    tensor = torch.tensor([rank + 1.0], dtype=torch.float32).to(device, non_blocking=True)

    # Perform the all-reduce operation
    dist.all_reduce(tensor, op=dist.ReduceOp.SUM)
    dist.barrier()

    # The result should be the sum of all ranks
    expected_value = sum(range(1, size + 1))
    is_correct = torch.tensor([1 if tensor.item() == expected_value else 0], dtype=torch.int32)

    # Prepare gather list only on rank 0
    gather_list = [torch.empty(1, dtype=torch.int32) for _ in range(size)] if rank == 0 else None

    # Gather correctness information at rank 0
    dist.gather(is_correct, gather_list=gather_list, dst=0)

    if rank == 0:
        incorrect_ranks = [i for i, correct in enumerate(gather_list) if correct.item() == 0]
        if len(incorrect_ranks) == 0:
            print("Success: All ranks received the correct value.")
        else:
            print(f"Incorrect ranks: {incorrect_ranks}")

    # Clean up the distributed environment
    cleanup_distributed()

if __name__ == "__main__":
    test_allreduce()