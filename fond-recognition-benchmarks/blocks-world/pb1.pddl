(define (problem bw-pb1)
  (:domain blocks-domain)
  (:objects a b c d e f g h i j - block)
  (:init (emptyhand) (on a f) (ontable b) (on c h) (on d g) (on e i) (ontable j) (ontable f) (on g c) (on h a) (on i b) (clear d) (clear e) (clear j))
  (:goal (and (goal_state)))
)