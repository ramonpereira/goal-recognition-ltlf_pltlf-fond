(define (problem bw_0)
  (:domain blocks-domain)
  (:objects a b c d - block)
  (:init 
  		(emptyhand) 
  		(ontable c) (on a c) (clear a)
  		(ontable d) (on b d) (clear b))
  (:goal 
  	(and 
  		(on a  b) (holding c)

  	)
  )
)
