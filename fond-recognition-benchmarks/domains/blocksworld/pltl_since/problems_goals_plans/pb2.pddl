(define (problem pb2)
  (:domain blocks-domain)
  (:objects a b c d e f g h i - block)
  (:init 
      (emptyhand)
      (ontable g) (clear g)
      (ontable h) (on i h) (clear i) 
      (ontable c) (on a c) (on b a) (clear b)
      (ontable d) (on e d) (on f e) (clear f))
  (:goal 
    (and 
      (goal_state)
    )
  )
)
