(define (problem pb1)
  (:domain blocks-domain)
  (:objects a b c d e f h g - block)
  (:init 
      (emptyhand)
      (ontable h) (clear h) 
      (ontable g) (clear g)
      (ontable c) (on a c) (on b a) (clear b)
      (ontable d) (on e d) (on f e) (clear f))
  (:goal 
    (and 
      (goal_state)
    )
  )
)
