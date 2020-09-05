(define (problem bw_0)
  (:domain blocks-domain)
  (:objects a b c d e f g - block)
  (:init 
  		(emptyhand) 
  		(ontable c) (on a c) (on b a) (clear b)
  		(ontable d) (on e d) (on f e) (clear f))
  (:goal 
  	(and 
  		(goal_state)
  	)
  )
)
