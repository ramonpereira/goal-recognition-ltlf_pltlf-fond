
(define (problem triangle-tire-1)
  (:domain triangle-tire)
  (:objects l11 l12 l13 l21 l22 l23 l31 l32 l33 - location)
  (:init 
  		(vehicleat l11) 
  		(road l11 l12) (road l12 l13) 
  		(road l11 l21) (road l12 l22) 
  		(road l21 l12) (road l22 l13) 
  		(road l21 l31) (road l31 l22)
		(sparein l21) (sparein l22)
  		(sparein l31) (sparein l31) 
  		(notflattire)
  )
  (:goal (vehicleat l13)))

