#lang racket

(require racket/vector)
(require rackunit)

(define (redist-memory blocks)
  (let* ([total-blocks (vector-length blocks)]
         [donor-pos    (vector-member (vector-argmax identity blocks) blocks)]
         [mem-total    (vector-ref blocks donor-pos)]
         [mem-each     (max 1 (quotient mem-total (sub1 total-blocks)))])
    (begin (vector-set! blocks donor-pos 0)
           (for ([i (in-range (* 2 total-blocks))])
             (let ([loc     (modulo (+ i 1 donor-pos) total-blocks)]
                   [mem-cur (max 0 (min mem-each (- mem-total (* i mem-each))))])
               (vector-set! blocks loc (+ mem-cur (vector-ref blocks loc))))))))

(define (max-wrap-steps blocks)
  (let ([blocks  (vector-copy blocks)]
        [visited (make-hash)])
    (for ([i (in-naturals)])
      ; iterate until get into already visited position
      #:break (hash-has-key? visited blocks)
           (begin (hash-set! visited (vector-copy blocks) (hash-count visited))
                  (redist-memory blocks)))
    (cons (hash-count visited) (hash-ref visited blocks))))

; unit test
(define test-input (vector 0 2 7 0))
(check-equal? (max-wrap-steps test-input) '(5 . 1))

; solution
(define input (list->vector (file->list "input.txt")))
(define ans (max-wrap-steps input))
(display (format "Part 1: ~a\nPart 2: ~a\n" (car ans) (- (car ans) (cdr ans))))
