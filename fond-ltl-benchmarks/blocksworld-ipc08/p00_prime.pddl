(define (problem bw_0)
	(:domain blocks-domain)
	(:objects a b c d e - block)
	(:init (clear b) (clear e) (emptyhand) (on a c) (on b a) (on e d) (ontable c) (ontable d) (q1 b e) (turnDomain))
(:goal (and (q3 b e) (turnDomain)))
)