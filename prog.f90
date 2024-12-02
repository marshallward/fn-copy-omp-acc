use test_mod, only : test_subrt

implicit none

integer, parameter :: n = 10**5
real :: x(n), y(n), z(n)

integer :: k, nk

x(:) = 1.
y(:) = 2.

read(*,*) nk

print *, "nk is", nk

!$omp target enter data map(to: x, y)
!$acc enter data copyin(x, y)

do k = 1, nk
  call test_subrt(x, y, z)
enddo

!$omp target exit data map(from: z)
!$acc exit data copyout(z)

print *, sum(z)
end