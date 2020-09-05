(define (problem pb2)
  (:domain triangle-tire)
  (:objects l11 l12 l13 l14 l15 l16 l17 l21 l22 l23 l24 l25 l26 l27 l31 l32 l33 l34 l35 l36 l37 l41 l42 l43 l44 - location)
  (:init 
      (vehicleat l17)
      (road l11 l12) (road l12 l13) 
      (road l12 l11) (road l12 l14)
      (road l13 l14) (road l14 l15) 
      (road l15 l16) (road l16 l17)
      (road l17 l15) (road l17 l31) 
      (road l21 l11) (road l12 l22) 
      (road l13 l23) (road l14 l24) 
      (road l16 l26) 
      (road l21 l12) (road l22 l13) 
      (road l22 l12) (road l15 l26)
      (road l15 l22) (road l22 l33)
      (road l22 l32) (road l22 l23)
      (road l23 l14) (road l24 l15) 
      (road l25 l16) (road l26 l17) 
      (road l25 l26) (road l24 l25)
      (sparein l11) (sparein l13)
      (sparein l12) (sparein l15)
      (sparein l17) (sparein l14)
      (sparein l21) (sparein l22) 
      (sparein l23) (sparein l24) 
      (sparein l25) (sparein l26) 
      
      (road l31 l32) (road l32 l33) 
      (road l33 l32) (road l22 l31)
      (road l33 l34) (road l34 l35) 
      (road l34 l25) (road l34 l35)
      (road l34 l24) (road l32 l22) 
      (road l33 l22) (road l33 l43)
      (road l21 l31) (road l23 l33) 
      (road l25 l35) (road l31 l22) 
      (road l33 l24) (road l35 l26) 
      (sparein l31) (sparein l35)
      (sparein l32) (sparein l36)
      (sparein l33) (sparein l34)

      (road l31 l41) (road l32 l42) 
      (road l33 l43) (road l34 l44) 
      (road l41 l32) (road l42 l33) 
      (road l41 l42)
      (road l43 l34) (road l44 l35) 
      (road l35 l44) (road l33 l44) 
      (road l33 l42) (road l26 l35)
      (road l44 l34) (road l44 l33) 
      (road l43 l42) (road l42 l41)
      (sparein l41) (sparein l42) 
      (sparein l43) (sparein l44) 
      (notflattire))
  (:goal (goal_state)))
  
