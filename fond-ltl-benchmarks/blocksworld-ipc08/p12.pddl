(define (problem bw_10_12)
  (:domain blocks-domain)
  (:objects b1 b2 b3 b4 b5 b6 b7 b8 b9 b10 - block)
  (:init (emptyhand) (ontable b1) (on b2 b7) (ontable b3) (on b4 b6) (on b5 b10) (on b6 b1) (ontable b7) (on b8 b3) (on b9 b5) (on b10 b4) (clear b2) (clear b8) (clear b9))
  (:goal (and (emptyhand) (on b1 b3) (on b2 b9) (ontable b3) (on b4 b10) (on b5 b7) (on b6 b4) (ontable b7) (on b8 b2) (on b9 b1) (on b10 b8) (clear b5) (clear b6)))
)
