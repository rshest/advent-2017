module solution
implicit none
contains

subroutine parse_input(fname, res)
  character(*) :: fname
  character(:), allocatable :: buffer
  integer :: i, n, rows = 0, pos1 = 1, pos2
  integer, dimension(:, :), allocatable, intent(out) :: res

  open(unit=1, file=fname, action="read", form="unformatted", access="stream")
  inquire(unit=1, size=n)
  allocate(character(n) :: buffer)
  read(1) buffer
  close(1)

  do
    pos2 =  index(buffer(pos1:), ":")
    if (pos2 == 0) then
       exit
    end if
    pos1 = pos1 + pos2 - 1
    buffer(pos1:pos1) = ","
    rows = rows + 1
  end do

  allocate(res(2, rows))
  read(buffer, *) res
end subroutine parse_input

subroutine simulate(input, delay, compute_severity, caught, severity)
    integer, dimension(:, :), allocatable :: input
    logical :: compute_severity
    integer :: delay
    integer :: severity, range, step, i
    logical :: caught

    severity = 0
    caught = .false.

    do i = 1, size(input, 2)
      step = input(1, i)
      range = input(2, i)
      if (mod(delay + step + 1, range*2 - 2) == 1) then
        caught = .true.
        if (.not. compute_severity) then
          exit
        end if
        severity = severity + step*range
      end if
    end do
end subroutine simulate

function find_min_delay(input) result(delay)
    integer, dimension(:, :), allocatable :: input
    integer :: delay
    integer :: severity
    logical :: caught

    caught = .false.
    delay = 0
    do
      call simulate(input, delay, .false., caught, severity)
      if (.not. caught) then
        exit
      end if
      delay = delay + 1
    end do
end function find_min_delay

end module solution

program main
  use solution
  integer, dimension(:, :), allocatable :: input
  integer :: severity
  logical :: caught = .false.

  call parse_input("input.txt", input)
  call simulate(input, 0, .true., caught, severity)
  print *, "Part 1: ", severity
  print *, "Part 2: ", find_min_delay(input)

  deallocate(input)
end program main
