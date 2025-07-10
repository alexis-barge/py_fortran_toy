program toy_particules

use part_solver
use part_data
use worker

implicit none

integer :: ite
real :: step, total_time


        ! local variables
        integer :: istp

        print*, "Particle toy solver"

        ! init
        if (worker_rank == master) print*, "================ INIT ===================="
        call init_solver(part_list_1,ite,step)
        call write_data(part_list_1,0)
        total_time = 0.0

        ! run
        if (worker_rank == master) print*, "================ RUN ===================="
        do istp = 1, ite
            ! solve current iteration
            if (worker_rank == master) print*, "Iteration: ", istp, " ; step = ", step," s ; Total Time: ", total_time
            call solver_euler(part_list_1,step)

            ! advance total time
            total_time = total_time + step

            ! dump particles
            if ( mod(istp,5) .eq. 0 ) then
               call write_data(part_list_1,istp)
            endif
        enddo
        
        ! write final results
        call write_data(part_list_1,istp)

        ! free memory
        if (worker_rank == master) print*, "================ CLEANING ===================="
        call destroy_solver()


end program toy_particules
