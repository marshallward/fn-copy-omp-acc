module test_mod
  implicit none
contains
  subroutine test_subrt(x, y, z)
    real, intent(in) :: x(:), y(:)
    real, intent(out) :: z(:)

    integer :: n
    integer :: i

    n = size(x)

    !$acc data present(x, y, z)

    !$omp target
    !$omp parallel loop
    !$acc kernels
    do i = 1, n
      z(i) = x(i) + y(i)
    enddo
    !$omp end target
    !$acc end kernels

    !$acc end data

  end subroutine test_subrt
end module test_mod
