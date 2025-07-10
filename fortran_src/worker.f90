module worker

   use mpi
   implicit none
   public

   integer :: worker_rank, worker_size, worker_comm
   integer, parameter :: master = 0

   contains


   subroutine init_workers(comm)
        ! i/o
        integer, intent(in), optional :: comm 
        ! local variables
        integer :: ierr
       
        ! set communicator
        if (present(comm)) then
           worker_comm = comm
        else
           worker_comm = MPI_COMM_WORLD 
           call MPI_Init(ierr)
        end if

        call MPI_Comm_rank(worker_comm, worker_rank, ierr)
        call MPI_Comm_size(worker_comm, worker_size, ierr)

   end subroutine init_workers


   subroutine part_in_workers(Np,iNp,istart)
        ! i/o
        integer, intent(in)  :: Np
        integer, intent(out) :: iNp, istart
        ! local variables
        integer :: worker_lim, first_guess

        first_guess = Np / worker_size
        worker_lim = mod(Np,worker_size) - 1
        if (worker_rank <= worker_lim ) then
           iNp = first_guess + 1
           istart = worker_rank * (first_guess+1) + 1
        else if (worker_rank > worker_lim .and. worker_lim .ne. -1) then
           iNp = first_guess
           istart = (worker_lim+1) * (first_guess + 1) + ( worker_rank - worker_lim - 1 ) * first_guess + 1  
        else
           iNp = first_guess
           istart = worker_rank * first_guess + 1
        end if

   end subroutine part_in_workers


   subroutine finalize_workers()
        ! local variables
        integer :: ierr

        call MPI_Finalize(ierr)

   end subroutine finalize_workers

end module worker
