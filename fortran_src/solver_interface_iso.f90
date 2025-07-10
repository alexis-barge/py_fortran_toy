function get_size_iso(list) result(siz) BIND(C)

        use iso_c_binding
        use mod_part
        implicit none

        ! i/o
        integer (c_int), intent(in)  :: list
        integer (c_int)              :: siz

        if (list.eq.1) then
           siz = size(part_list_1)
        else if (list.eq.2) then
           siz = size(part_list_2)
        else
           siz = -1
        end if

end function get_size_iso


subroutine get_data_iso(list,siz,ids,poss,vels) BIND(C)

        use iso_c_binding
        use mod_part
        implicit none

        ! i/o
        integer (c_int), intent(in) :: list
        integer (c_int), intent(in) :: siz
        integer (c_int), intent(out) :: ids(siz)
        real (c_float), intent(out)  :: poss(siz*3), vels(siz*3)
        ! local variables
        integer :: i, j

        if (list.eq.1) then
           do i = 1, size(part_list_1)
              j = (i-1)*3 + 1
              ids(i) = part_list_1(i)%id
              poss(j:j+2) = part_list_1(i)%pos(1:3)
              vels(j:j+2) = part_list_1(i)%vel(1:3)
           end do 
        else if (list.eq.2) then
           do i = 1, size(part_list_2)
              j = (i-1)*3 + 1
              ids(i) = part_list_2(i)%id
              poss(j:j+2) = part_list_2(i)%pos(1:3)
              vels(j:j+2) = part_list_2(i)%vel(1:3)
           end do 
        end if

end subroutine get_data_iso


subroutine set_data_iso(list,siz,ids,poss,vels) BIND(C)

        use iso_c_binding
        use mod_part
        implicit none

        ! i/o
        integer (c_int), intent(in) :: list
        integer (c_int), intent(in) :: siz
        integer (c_int), intent(out) :: ids(siz)
        real (c_float), intent(out)  :: poss(siz*3), vels(siz*3)
        ! local variables
        integer :: i, j, k, l

        if (list.eq.1) then
           do i = 1, siz
              k = ids(i)
              j = (i-1)*3 + 1
              do l = 1, size(part_list_1)
                 if (part_list_1(l)%id == k) then
                    part_list_1(l)%pos(1:3) = poss(j:j+2)
                    part_list_1(l)%vel(1:3) = vels(j:j+2)
                 end if
              end do
           end do 
        else if (list.eq.2) then
           do i = 1, siz
              k = ids(i)
              j = (i-1)*3 + 1
              do l = 1, size(part_list_2)
                 if (part_list_2(l)%id == k) then
                    part_list_2(l)%pos(1:3) = poss(j:j+2)
                    part_list_2(l)%vel(1:3) = vels(j:j+2)
                 end if
              end do
           end do 
        end if

end subroutine set_data_iso


subroutine write_data_iso(stp,list1,list2) BIND(C)

        use iso_c_binding, only: c_int
        use mod_part
        implicit none

        ! i/o
        integer (c_int), intent(in) :: stp, list1, list2
        ! local variables
        integer :: stp_f, l1, l2

        ! conversion
        stp_f = stp
        l1 = list1
        l2 = list2

        ! appel fortran
        if (l1.eq.1) call write_data(part_list_1,stp_f)
        if (l2.eq.1) call write_data(part_list_2,stp_f)

end subroutine write_data_iso


subroutine init_iso(comm) BIND(C)

        use iso_c_binding, only: c_int
        use mod_part
        implicit none

        ! i/o
        integer (c_int), intent(in) :: comm

        call init_workers(comm)

end subroutine init_iso


subroutine create_solver_iso(npart1,npart2) BIND(C)

        use iso_c_binding, only: c_int, c_float
        use mod_part
        implicit none

        ! i/o
        integer (c_int), intent(in)    :: npart1, npart2
        ! local variables
        integer                 :: np1, inp1, np2, inp2, istart

        ! conversion
        np1 = npart1
        np2 = npart2

        ! initialize if Np > 0
        if (np1 .gt. 0) then
            call part_in_workers(np1,inp1,istart)
            call init_data(inp1,istart,part_list_1)
        end if
        if (np2 .gt. 0) then
            call part_in_workers(np2,inp2,istart)
            call init_data(inp2,inp2,part_list_2)
        end if

end subroutine create_solver_iso


subroutine solver_euler_iso(nite,step,list_1,list_2) BIND(C)

        use iso_c_binding, only: c_int, c_float
        use mod_part
        implicit none

        ! i/o
        integer (c_int), intent(in)     :: nite, list_1, list_2
        real (c_float), intent(in)      :: step
        ! local variables
        integer                      :: nite_f, l1, l2, i
        real                         :: step_f

        ! conversion
        step_f = step
        nite_f = nite
        l1 = list_1
        l2 = list_2

        ! appel fortran
        do i = 1, nite_f
           if (l1.eq.1) call solver_euler(part_list_1,step_f)
           if (l2.eq.1) call solver_euler(part_list_2,step_f)
        end do

end subroutine solver_euler_iso


subroutine solver_RK2_iso(nite,step,list_1,list_2) BIND(C, name="solver_RK2_iso")

        use iso_c_binding, only: c_int, c_float
        use mod_part
        implicit none

        ! i/o
        integer (c_int), intent(in)     :: nite, list_1, list_2
        real (c_float), intent(in)      :: step
        ! local variables
        integer                      :: nite_f, l1, l2, i
        real                         :: step_f

        ! conversion
        step_f = step
        nite_f = nite
        l1 = list_1
        l2 = list_2

        ! appel fortran
        do i = 1, nite_f
           if (l1.eq.1) call solver_RK2(part_list_1,step_f)
           if (l2.eq.1) call solver_RK2(part_list_2,step_f)
        end do

end subroutine solver_RK2_iso


subroutine destroy_solver_iso() BIND(C)

        use mod_part
        implicit none

        ! i/o
        ! local variables

        ! appel fortran
        call destroy_solver()

end subroutine destroy_solver_iso
