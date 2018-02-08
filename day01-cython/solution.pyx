
cpdef captcha(str digits, int next_char_offset=1):
    digits_ascii = digits.encode()
    cdef char* digits_ptr = digits_ascii

    cdef int num_digits = len(digits), res = 0, i
    cdef char c, cnext, c0 = ord('0')

    for i in range(num_digits):
        c = digits_ptr[i]
        cnext = digits_ptr[(i + next_char_offset)%num_digits]
        res += (c - c0)*int(c == cnext)

    return res


cpdef captcha2(str digits):
    return captcha(digits, int(len(digits)/2))


cpdef solution(input_file='input.txt'):
    with open(input_file) as f:
        input = f.read().strip()

    print("Solution 1: {}".format(captcha(input)))
    print("Solution 2: {}".format(captcha2(input)))
