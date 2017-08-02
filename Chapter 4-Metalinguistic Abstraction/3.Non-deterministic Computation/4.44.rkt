(define (safe-row? row1 row2)
  (not (= row1 row2)))

(define (safe-diagonal? row1 row2 col1 col2)
  (not (= (- col2 col1)
          (abs (- row2 row1)))))

(define (safe? k positions)
  (let ((kth-row (list-ref positions (- k 1))))
    (define (safe-iter p col)
      (if (= col k)
          true
          (if (and (safe-row? (car p) kth-row)
                   (safe-diagonal? (car p) kth-row
                                   col k))
              (safe-iter (cdr p) (+ col 1)))))
    (safe-iter positions 1)))

(define (list-amb li)
  (if (null? li)
      (amb)
      (amb (car li) (list-amb (cdr li)))))

(define (enumerate-interval low high)
  (if (> low high)
      '()
      (cons low (enumerate-interval (+ low 1) high))))

(define (queen board-size)
  (define (queen-iter k positions)
    (if (= k board-size)
        positions
        (let ((row (list-amb (enumerate-interval 1 board-size))))
          (let ((new-pos (append positions (list row))))
            (require (safe? k new-pos))
            (queen-iter (+ k 1) new-pos)))))
  (queen-iter 1 '()))