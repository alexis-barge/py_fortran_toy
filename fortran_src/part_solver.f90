module part_solver

use part_data
use worker
use in_out

implicit none

contains

    subroutine init_solver(part_list,ite,step)
        ! i/0
        type(part), allocatable :: part_list(:)
        integer :: ite
        real :: step
        ! local variables
        integer :: Np, iNp, istart
        ! -------------

        ! init parallel environment
        call init_workers()

        ! read params
        call read_param_from_file('param.txt',Np,ite,step)

        ! split up number of particles
        call part_in_workers(Np,iNp,istart)

        ! init particles list
        call init_data(iNp,istart,part_list)

    end subroutine init_solver

    ! ------------------------

    subroutine solver_euler(part_list,step)
        ! i/0
        type(part) :: part_list(:)
        real :: step
        ! local variables
        integer :: i
        real :: length
        ! ---------------------

        length = 10.0
        do i = 1, size(part_list)
            ! advance
            part_list(i)%pos(1) = part_list(i)%pos(1) + step * part_list(i)%vel(1)
            part_list(i)%pos(2) = part_list(i)%pos(2) + step * part_list(i)%vel(2)
            part_list(i)%pos(3) = part_list(i)%pos(3) + step * part_list(i)%vel(3)

            ! periodicity
            part_list(i)%pos(1) = part_list(i)%pos(1) - length * floor(part_list(i)%pos(1) / length + 0.5)
            part_list(i)%pos(2) = part_list(i)%pos(2) - length * floor(part_list(i)%pos(2) / length + 0.5)
            part_list(i)%pos(3) = part_list(i)%pos(3) - length * floor(part_list(i)%pos(3) / length + 0.5)
        end do

    end subroutine solver_euler

    ! ------------------------

    subroutine solver_RK2(part_list,step)
        ! i/0
        type(part) :: part_list(:)
        real :: step
        ! local variables
        integer :: i
        real :: length
        ! ---------------------

        length = 10.0
        do i = 1, size(part_list)
            ! advance
            part_list(i)%pos(1) = part_list(i)%pos(1) + step**2 * part_list(i)%vel(1)
            part_list(i)%pos(2) = part_list(i)%pos(2) + step**2 * part_list(i)%vel(2)
            part_list(i)%pos(3) = part_list(i)%pos(3) + step**2 * part_list(i)%vel(3)

            ! periodicity
            part_list(i)%pos(1) = part_list(i)%pos(1) - length * floor(part_list(i)%pos(1) / length + 0.5)
            part_list(i)%pos(2) = part_list(i)%pos(2) - length * floor(part_list(i)%pos(2) / length + 0.5)
            part_list(i)%pos(3) = part_list(i)%pos(3) - length * floor(part_list(i)%pos(3) / length + 0.5)
        end do

    end subroutine solver_RK2

    ! ------------------------

    subroutine destroy_solver()

        ! deallocate
        if (allocated(part_list_1)) deallocate(part_list_1)
        if (allocated(part_list_2)) deallocate(part_list_2)
        if (worker_rank == master) print*, "Particle list deallocated"

        ! free worker
        call finalize_workers()

    end subroutine destroy_solver

end module part_solver
