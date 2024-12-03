use test_mod, only : test_subrt

implicit none

integer, parameter :: n = 10**5
real :: x(n), y(n), z(n)

integer :: nargs
character(len=8) :: arg

integer :: k, nk

nargs = command_argument_count()
print *, nargs
if (nargs == 0) then
  print *, "Usage: prog [n], where [n] is the number of iterations."
  stop
endif

call get_command_argument(1, arg)
read(arg, *) nk

print *, "nk is", nk

x(:) = 1.
y(:) = 2.

!$omp target enter data map(to: x, y) map(alloc: z)
!$acc enter data copyin(x, y) create(z)

do k = 1, nk
  call test_subrt(x, y, z)
enddo

!$omp target exit data map(from: z)
!$acc exit data copyout(z)

print *, sum(z)
end
