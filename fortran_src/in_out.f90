module in_out

contains

    subroutine read_param_from_file(file,npart,ite,step)
        ! i/0
        character(len=20) :: file
        real :: step
        integer :: ite, npart
        ! ------------

        open(10,file=trim(file))
            read(10,*) npart
            read(10,*) ite
            read(10,*) step
        close(10)

    end subroutine read_param_from_file

end module in_out
