module part_data

use in_out
use worker

implicit none
public

type part
    integer :: id
    real, dimension(3) :: pos
    real, dimension(3) :: vel
end type

type(part), dimension(:), allocatable, save :: part_list_1
type(part), dimension(:), allocatable, save :: part_list_2

contains

    subroutine init_data(Np,start,part_list)
        ! i/o
        type(part), allocatable :: part_list(:)
        integer :: Np, start
        ! local variables
        integer :: i
        real :: rand(6)
        ! ----------------

        ! init RNG
        call random_seed()

        ! init particle list
        allocate(part_list(Np))

        ! initialize values
        do i = 1, Np
            call random_number(rand)
            part_list(i)%id = start + (i-1)
            part_list(i)%pos(1) = rand(1) * 10.0
            part_list(i)%pos(2) = rand(2) * 10.0
            part_list(i)%pos(3) = rand(3) * 10.0
            part_list(i)%vel(1) = rand(4) * 2.0 - 1.0
            part_list(i)%vel(2) = rand(5) * 2.0 - 1.0
            part_list(i)%vel(3) = rand(6) * 2.0 - 1.0
        end do

    end subroutine init_data

    ! ----------------------------

    subroutine write_data(part_list,ite)
        ! i/o
        type(part) :: part_list(:)
        integer :: ite
        ! local variables
        character(len=200), allocatable :: buffer(:)
        character(len=20) :: outfile
        integer :: npart, i, ierr, fh, nloc, count
        integer :: status(MPI_STATUS_SIZE)
        ! --------------------------

        ! buffer
        nloc = size(part_list)
        allocate(buffer(nloc))
        buffer = ' '
        do i = 1, nloc
           write(buffer(i), '(I3,1X,6E15.7)') part_list(i)%id, part_list(i)%pos, part_list(i)%vel
           buffer(i)(200:200) = CHAR(10)
        enddo

        ! output name
        write(outfile,'(a,I3.3,a)') "Part_", ite, ".dat"
        if (worker_rank == master) print*, "Write results in ", trim(outfile)

        ! open
        call MPI_File_open(worker_comm,outfile,MPI_MODE_CREATE + MPI_MODE_WRONLY, MPI_INFO_NULL, fh, ierr)
        call MPI_File_set_view(fh,0_MPI_OFFSET_KIND,MPI_CHARACTER,MPI_CHARACTER,'native',MPI_INFO_NULL,ierr)

        ! write
        count = nloc * 200
        call MPI_File_write_ordered(fh, buffer, count, MPI_CHARACTER, status, ierr) 

        ! close
        call MPI_File_close(fh,ierr)
        deallocate(buffer)

    end subroutine write_data

end module part_data
